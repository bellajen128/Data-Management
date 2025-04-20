import streamlit as st
import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import altair as alt
from wordcloud import WordCloud, STOPWORDS

# Database configuration
db_config = {
    'host':     'localhost',
    'user':     'root',
    'password': '<user password>',
    'database': 'DatingApp'
}

@st.cache_data
def load_data():
    try:
        conn = mysql.connector.connect(**db_config)
    except mysql.connector.Error as err:
        st.error(f"Database connection error: {err}")
        return pd.DataFrame()
    df = pd.read_sql(
        "SELECT Username, Age, GenderIdentity, Location, UserID, Bio FROM Users;",
        conn
    )
    conn.close()
    return df

@st.cache_data
def load_likes():
    conn = mysql.connector.connect(**db_config)
    likes = pd.read_sql("SELECT LikeeUserID FROM Likes;", conn)
    conn.close()
    return likes

# Load data
df_users = load_data()
df_likes = load_likes()

# Compute global max likes for slider
global_counts     = df_likes['LikeeUserID'].value_counts()
global_max_likes  = int(global_counts.max()) if not global_counts.empty else 0

# -------------------------------
# Interactive Elements
# -------------------------------
st.title("Dating App Data Visualization")
st.markdown("### Interactive Data Exploration")

if df_users.empty:
    st.error("No data loaded. Please check your database connection parameters.")
    st.stop()

# Sidebar filters: Gender, Age, Location, Min Likes Received
with st.sidebar:
    st.header("Filter Options")

    # Gender
    selected_gender = st.selectbox(
        "Select Gender",
        options=["All"] + sorted(df_users["GenderIdentity"].unique().tolist())
    )

    # Age range
    min_age, max_age = int(df_users["Age"].min()), int(df_users["Age"].max())
    age_range = st.slider(
        "Select Age Range",
        min_value=min_age,
        max_value=max_age,
        value=(min_age, max_age)
    )

    # Location
    locations = sorted(df_users["Location"].unique().tolist())
    selected_location = st.selectbox(
        "Select Location",
        options=["All"] + locations
    )

    # Min Likes Received
    min_likes = st.slider(
        "Min Likes Received",
        min_value=0,
        max_value=global_max_likes,
        value=0,
        step=1
    )

# Apply user filters
filtered_df = df_users.copy()
if selected_gender != "All":
    filtered_df = filtered_df[filtered_df["GenderIdentity"] == selected_gender]
filtered_df = filtered_df[
    (filtered_df["Age"] >= age_range[0]) &
    (filtered_df["Age"] <= age_range[1])
]
if selected_location != "All":
    filtered_df = filtered_df[filtered_df["Location"] == selected_location]

# -------------------------------
# Visualizations Section
# -------------------------------
st.markdown("### Visualizations")

# 1) Bio Word Cloud
st.markdown("#### Bio Word Cloud")
text = " ".join(df_users['Bio'].fillna(""))
wc = WordCloud(
    width=800, height=400,
    stopwords=set(STOPWORDS),
    background_color="white",
    colormap="plasma"
).generate(text)
fig, ax = plt.subplots(figsize=(10, 5))
ax.imshow(wc, interpolation='bilinear')
ax.axis('off')
st.pyplot(fig)

# 2) Gender counts & average ages
gender_counts = filtered_df['GenderIdentity'].value_counts().to_dict()
male_count    = gender_counts.get("Male", 0)
female_count  = gender_counts.get("Female", 0)

male_ages     = filtered_df.loc[filtered_df['GenderIdentity'] == 'Male', 'Age']
female_ages   = filtered_df.loc[filtered_df['GenderIdentity'] == 'Female', 'Age']
male_avg_age  = male_ages.mean() if not male_ages.empty else None
female_avg_age= female_ages.mean() if not female_ages.empty else None

male_avg_disp   = f"{male_avg_age:.1f}" if male_avg_age is not None else "—"
female_avg_disp = f"{female_avg_age:.1f}" if female_avg_age is not None else "—"

col1, col2 = st.columns(2)
col1.metric("👨 Male Users", male_count)
col2.metric("👩 Female Users", female_count)

col3, col4 = st.columns(2)
col3.metric("Avg Age", male_avg_disp)
col4.metric("Avg Age", female_avg_disp)

# 3) Age Histogram by Gender
st.markdown("#### Age Distribution of Users")
gender_colors = alt.Scale(domain=["Male", "Female"], range=["#66b3ff","#ff9999"])
age_hist = (
    alt.Chart(filtered_df)
    .mark_bar()
    .encode(
        alt.X("Age:Q", bin=alt.Bin(maxbins=30), title="Age", axis=alt.Axis(format="d")),
        alt.Y("count()", title="Number of Users", axis=alt.Axis(format="d")),
        alt.Color("GenderIdentity:N", title="Gender", scale=gender_colors),
        tooltip=["GenderIdentity:N", "count()"]
    )
    .properties(width=600, height=300)
)
st.altair_chart(age_hist, use_container_width=True)

# 4) Most Popular Users (by Likes Received)
st.markdown("#### Most Popular Users (by Likes Received)")

# Filter likes to current users
likes_filt = df_likes[df_likes["LikeeUserID"].isin(filtered_df["UserID"])]

# Count likes per recipient and merge usernames & gender
pop = (
    likes_filt
    .groupby("LikeeUserID")
    .size()
    .reset_index(name="LikesReceived")
    .merge(
        filtered_df[["UserID", "Username", "GenderIdentity"]],
        left_on="LikeeUserID",
        right_on="UserID",
        how="left"
    )
)

# Apply minimum likes filter
pop = pop[pop["LikesReceived"] >= min_likes]

if pop.empty:
    st.warning(f"No users have ≥ {min_likes} likes under the current filters.")
else:
    top = pop.sort_values("LikesReceived", ascending=False).iloc[0]
    st.metric("🏆 Top User", top["Username"], f"{top['LikesReceived']} Likes")

    chart = (
        alt.Chart(pop.sort_values("LikesReceived", ascending=False).head(10))
        .mark_bar()
        .encode(
            x=alt.X("LikesReceived:Q", title="Likes Received", axis=alt.Axis(format="d")),
            y=alt.Y("Username:N", sort="-x", title="User"),
            color=alt.Color("GenderIdentity:N", title="Gender", scale=gender_colors),
            tooltip=["Username:N", "LikesReceived:Q", "GenderIdentity:N"]
        )
        .properties(width=600, height=400)
    )
    st.altair_chart(chart, use_container_width=True)

# 5) Geolocation Map (Interactive)
st.markdown("#### Geolocation Map")
location_coords = {
    "Seattle":       {"lat": 47.6062,  "lon": -122.3321},
    "Los Angeles":   {"lat": 34.0522,  "lon": -118.2437},
    "Chicago":       {"lat": 41.8781,  "lon": -87.6298},
    "New York":      {"lat": 40.7128,  "lon": -74.0060},
    "San Francisco": {"lat": 37.7749,  "lon": -122.4194}
}

map_data_list = []
for _, row in filtered_df.iterrows():
    loc = row["Location"]
    if loc in location_coords:
        base_lat = location_coords[loc]["lat"]
        base_lon = location_coords[loc]["lon"]
        jitter_lat = base_lat + np.random.normal(scale=0.05)
        jitter_lon = base_lon + np.random.normal(scale=0.05)
        map_data_list.append({"lat": jitter_lat, "lon": jitter_lon})

if map_data_list:
    df_map = pd.DataFrame(map_data_list)
    st.map(df_map[["lat", "lon"]])
else:
    st.info("No geolocation data available for the selected locations.")
