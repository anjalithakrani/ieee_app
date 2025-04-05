const express = require("express")
const mongoose = require("mongoose")
const cors = require("cors")
const bcrypt = require("bcryptjs")
const jwt = require("jsonwebtoken")
const dotenv = require("dotenv")

// Load environment variables
dotenv.config()

// Initialize Express app
const app = express()
const PORT = process.env.PORT || 3000

// Middleware
app.use(cors())
app.use(express.json())

// MongoDB connection
mongoose
  .connect(process.env.MONGODB_URI || "mongodb://localhost:27017/campus_app", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.error("MongoDB connection error:", err))

// Models
const User = require("./models/User")
const Event = require("./models/Event")
const Post = require("./models/Post")
const Club = require("./models/Club")

// Auth middleware
const auth = require("./middleware/auth")

// Routes
const authRoutes = require("./routes/auth")
const eventRoutes = require("./routes/events")
const postRoutes = require("./routes/posts")
const clubRoutes = require("./routes/clubs")

app.use("/api/auth", authRoutes)
app.use("/api/events", eventRoutes)
app.use("/api/posts", postRoutes)
app.use("/api/clubs", clubRoutes)

// Default route
app.get("/", (req, res) => {
  res.send("Campus App API is running")
})

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})

