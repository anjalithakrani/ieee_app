const express = require("express")
const router = express.Router()
const auth = require("../middleware/auth")
const Post = require("../models/Post")
const User = require("../models/User")

// @route   GET api/posts
// @desc    Get all posts
// @access  Public
router.get("/", async (req, res) => {
  try {
    const posts = await Post.find().sort({ createdAt: -1 }).populate("authorId", ["name", "profileImage"])

    const formattedPosts = posts.map((post) => {
      const isLiked = req.user ? post.likes.some((like) => like.toString() === req.user.id) : false
      const isSaved = req.user ? post.savedBy.some((user) => user.toString() === req.user.id) : false

      return {
        id: post._id,
        authorId: post.authorId._id,
        authorName: post.authorId.name,
        authorImage: post.authorId.profileImage,
        content: post.content,
        imageUrl: post.imageUrl,
        likes: post.likes.length,
        comments: post.comments.length,
        timeAgo: getTimeAgo(post.createdAt),
        isLiked,
        isSaved,
      }
    })

    res.json(formattedPosts)
  } catch (err) {
    console.error(err.message)
    res.status(500).send("Server error")
  }
})

// @route   GET api/posts/:id
// @desc    Get post by ID
// @access  Public
router.get("/:id", async (req, res) => {
  try {
    const post = await Post.findById(req.params.id)
      .populate("authorId", ["name", "profileImage"])
      .populate("comments.user", ["name", "profileImage"])

    if (!post) {
      return res.status(404).json({ msg: "Post not found" })
    }

    const isLiked = req.user ? post.likes.some((like) => like.toString() === req.user.id) : false
    const isSaved = req.user ? post.savedBy.some((user) => user.toString() === req.user.id) : false

    const formattedPost = {
      id: post._id,
      authorId: post.authorId._id,
      authorName: post.authorId.name,
      authorImage: post.authorId.profileImage,
      content: post.content,
      imageUrl: post.imageUrl,
      likes: post.likes.length,
      comments: post.comments.map((comment) => ({
        id: comment._id,
        user: {
          id: comment.user._id,
          name: comment.user.name,
          profileImage: comment.user.profileImage,
        },
        text: comment.text,
        date: comment.date,
      })),
      timeAgo: getTimeAgo(post.createdAt),
      isLiked,
      isSaved,
    }

    res.json(formattedPost)
  } catch (err) {
    console.error(err.message)
    if (err.kind === "ObjectId") {
      return res.status(404).json({ msg: "Post not found" })
    }
    res.status(500).send("Server error")
  }
})

// @route   POST api/posts
// @desc    Create a post
// @access  Private
router.post("/", auth, async (req, res) => {
  const { content, imageUrl } = req.body

  try {
    const user = await User.findById(req.user.id).select("-password")

    const newPost = new Post({
      authorId: req.user.id,
      content,
      imageUrl,
    })

    const post = await newPost.save()

    const formattedPost = {
      id: post._id,
      authorId: user._id,
      authorName: user.name,
      authorImage: user.profileImage,
      content: post.content,
      imageUrl: post.imageUrl,
      likes: 0,
      comments: 0,
      timeAgo: "just now",
      isLiked: false,
      isSaved: false,
    }

    res.json(formattedPost)
  } catch (err) {
    console.error(err.message)
    res.status(500).send("Server error")
  }
})

// @route   PUT api/posts/:id/like
// @desc    Like a post
// @access  Private
router.put("/:id/like", auth, async (req, res) => {
  try {
    const post = await Post.findById(req.params.id)

    if (!post) {
      return res.status(404).json({ msg: "Post not found" })
    }

    // Check if the post has already been liked by this user
    if (post.likes.some((like) => like.toString() === req.user.id)) {
      // Unlike
      post.likes = post.likes.filter((like) => like.toString() !== req.user.id)
    } else {
      // Like
      post.likes.push(req.user.id)
    }

    await post.save()

    res.json({ likes: post.likes.length })
  } catch (err) {
    console.error(err.message)
    if (err.kind === "ObjectId") {
      return res.status(404).json({ msg: "Post not found" })
    }
    res.status(500).send("Server error")
  }
})

// @route   PUT api/posts/:id/save
// @desc    Save a post
// @access  Private
router.put("/:id/save", auth, async (req, res) => {
  try {
    const post = await Post.findById(req.params.id)

    if (!post) {
      return res.status(404).json({ msg: "Post not found" })
    }

    // Check if the post has already been saved by this user
    if (post.savedBy.some((user) => user.toString() === req.user.id)) {
      // Unsave
      post.savedBy = post.savedBy.filter((user) => user.toString() !== req.user.id)
    } else {
      // Save
      post.savedBy.push(req.user.id)
    }

    await post.save()

    res.json({ saved: post.savedBy.some((user) => user.toString() === req.user.id) })
  } catch (err) {
    console.error(err.message)
    if (err.kind === "ObjectId") {
      return res.status(404).json({ msg: "Post not found" })
    }
    res.status(500).send("Server error")
  }
})

// @route   POST api/posts/:id/comment
// @desc    Comment on a post
// @access  Private
router.post("/:id/comment", auth, async (req, res) => {
  const { text } = req.body

  try {
    const user = await User.findById(req.user.id).select("-password")
    const post = await Post.findById(req.params.id)

    if (!post) {
      return res.status(404).json({ msg: "Post not found" })
    }

    const newComment = {
      user: req.user.id,
      text,
      date: Date.now(),
    }

    post.comments.unshift(newComment)

    await post.save()

    res.json(post.comments)
  } catch (err) {
    console.error(err.message)
    if (err.kind === "ObjectId") {
      return res.status(404).json({ msg: "Post not found" })
    }
    res.status(500).send("Server error")
  }
})

// Helper function to format time ago
function getTimeAgo(date) {
  const seconds = Math.floor((new Date() - date) / 1000)

  let interval = Math.floor(seconds / 31536000)
  if (interval > 1) {
    return interval + " years"
  }
  if (interval === 1) {
    return interval + " year"
  }

  interval = Math.floor(seconds / 2592000)
  if (interval > 1) {
    return interval + " months"
  }
  if (interval === 1) {
    return interval + " month"
  }

  interval = Math.floor(seconds / 86400)
  if (interval > 1) {
    return interval + " days"
  }
  if (interval === 1) {
    return interval + " day"
  }

  interval = Math.floor(seconds / 3600)
  if (interval > 1) {
    return interval + " hours"
  }
  if (interval === 1) {
    return interval + " hour"
  }

  interval = Math.floor(seconds / 60)
  if (interval > 1) {
    return interval + " mins"
  }
  if (interval === 1) {
    return interval + " min"
  }

  return Math.floor(seconds) + " secs"
}

module.exports = router

