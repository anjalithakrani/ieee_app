const express = require("express")
const router = express.Router()
const bcrypt = require("bcryptjs")
const jwt = require("jsonwebtoken")
const auth = require("../middleware/auth")
const User = require("../models/User")

// @route   POST api/auth/register
// @desc    Register user
// @access  Public
router.post("/register", async (req, res) => {
  const { name, email, password, type } = req.body

  try {
    // Check if user exists
    let user = await User.findOne({ email })
    if (user) {
      return res.status(400).json({ msg: "User already exists" })
    }

    // Create new user
    user = new User({
      name,
      email,
      password,
      type,
      role: type === "student" ? "Student" : "Teacher",
    })

    // Save user to database
    await user.save()

    // Create JWT payload
    const payload = {
      user: {
        id: user.id,
      },
    }

    // Sign token
    jwt.sign(payload, process.env.JWT_SECRET || "secret", { expiresIn: "7d" }, (err, token) => {
      if (err) throw err
      res.json({
        token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          profileImage: user.profileImage,
          role: user.role,
          bio: user.bio,
          type: user.type,
        },
      })
    })
  } catch (err) {
    console.error(err.message)
    res.status(500).send("Server error")
  }
})

// @route   POST api/auth/login
// @desc    Authenticate user & get token
// @access  Public
router.post("/login", async (req, res) => {
  const { email, password, type } = req.body

  try {
    // Check if user exists
    const user = await User.findOne({ email, type })
    if (!user) {
      return res.status(400).json({ msg: "Invalid credentials" })
    }

    // Check password
    const isMatch = await user.comparePassword(password)
    if (!isMatch) {
      return res.status(400).json({ msg: "Invalid credentials" })
    }

    // Create JWT payload
    const payload = {
      user: {
        id: user.id,
      },
    }

    // Sign token
    jwt.sign(payload, process.env.JWT_SECRET || "secret", { expiresIn: "7d" }, (err, token) => {
      if (err) throw err
      res.json({
        token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          profileImage: user.profileImage,
          role: user.role,
          bio: user.bio,
          type: user.type,
        },
      })
    })
  } catch (err) {
    console.error(err.message)
    res.status(500).send("Server error")
  }
})

// @route   GET api/auth/user
// @desc    Get user data
// @access  Private
router.get("/user", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select("-password")
    res.json(user)
  } catch (err) {
    console.error(err.message)
    res.status(500).send("Server error")
  }
})

// @route   PUT api/auth/user
// @desc    Update user profile
// @access  Private
router.put("/user", auth, async (req, res) => {
  const { name, bio, profileImage } = req.body

  try {
    const user = await User.findById(req.user.id)
    if (!user) {
      return res.status(404).json({ msg: "User not found" })
    }

    // Update fields
    if (name) user.name = name
    if (bio) user.bio = bio
    if (profileImage) user.profileImage = profileImage

    await user.save()
    res.json(user)
  } catch (err) {
    console.error(err.message)
    res.status(500).send("Server error")
  }
})

module.exports = router

