const express = require("express")
const router = express.Router()
const auth = require("../middleware/auth")
const Event = require("../models/Event")
const User = require("../models/User")

// @route   GET api/events
// @desc    Get all events
// @access  Public
router.get("/", async (req, res) => {
  try {
    const events = await Event.find().sort({ date: 1 })
    res.json(events)
  } catch (err) {
    console.error(err.message)
    res.status(500).send("Server error")
  }
})

// @route   GET api/events/upcoming
// @desc    Get upcoming events
// @access  Public
router.get("/upcoming", async (req, res) => {
  try {
    // In a real app, you would filter by date
    const events = await Event.find().sort({ date: 1 }).limit(5)
    res.json(events)
  } catch (err) {
    console.error(err.message)
    res.status(500).send("Server error")
  }
})

// @route   GET api/events/today
// @desc    Get today's events
// @access  Public
router.get("/today", async (req, res) => {
  try {
    // In a real app, you would filter by today's date
    const events = await Event.find().sort({ time: 1 }).limit(3)
    res.json(events)
  } catch (err) {
    console.error(err.message)
    res.status(500).send("Server error")
  }
})

// @route   GET api/events/:id
// @desc    Get event by ID
// @access  Public
router.get("/:id", async (req, res) => {
  try {
    const event = await Event.findById(req.params.id)

    if (!event) {
      return res.status(404).json({ msg: "Event not found" })
    }

    res.json(event)
  } catch (err) {
    console.error(err.message)
    if (err.kind === "ObjectId") {
      return res.status(404).json({ msg: "Event not found" })
    }
    res.status(500).send("Server error")
  }
})

// @route   POST api/events
// @desc    Create an event
// @access  Private
router.post("/", auth, async (req, res) => {
  const { name, date, time, location, description, imageUrl, organizer } = req.body

  try {
    const newEvent = new Event({
      name,
      date,
      time,
      location,
      description,
      imageUrl,
      organizer,
    })

    const event = await newEvent.save()
    res.json(event)
  } catch (err) {
    console.error(err.message)
    res.status(500).send("Server error")
  }
})

// @route   POST api/events/:id/register
// @desc    Register for an event
// @access  Private
router.post("/:id/register", auth, async (req, res) => {
  try {
    const event = await Event.findById(req.params.id)

    if (!event) {
      return res.status(404).json({ msg: "Event not found" })
    }

    // Check if user is already registered
    if (event.attendees.some((attendee) => attendee.toString() === req.user.id)) {
      return res.status(400).json({ msg: "Already registered for this event" })
    }

    // Add user to attendees
    event.attendees.push(req.user.id)
    await event.save()

    res.json({ msg: "Successfully registered for event" })
  } catch (err) {
    console.error(err.message)
    if (err.kind === "ObjectId") {
      return res.status(404).json({ msg: "Event not found" })
    }
    res.status(500).send("Server error")
  }
})

// @route   DELETE api/events/:id/register
// @desc    Unregister from an event
// @access  Private
router.delete("/:id/register", auth, async (req, res) => {
  try {
    const event = await Event.findById(req.params.id)

    if (!event) {
      return res.status(404).json({ msg: "Event not found" })
    }

    // Check if user is registered
    if (!event.attendees.some((attendee) => attendee.toString() === req.user.id)) {
      return res.status(400).json({ msg: "Not registered for this event" })
    }

    // Remove user from attendees
    event.attendees = event.attendees.filter((attendee) => attendee.toString() !== req.user.id)

    await event.save()

    res.json({ msg: "Successfully unregistered from event" })
  } catch (err) {
    console.error(err.message)
    if (err.kind === "ObjectId") {
      return res.status(404).json({ msg: "Event not found" })
    }
    res.status(500).send("Server error")
  }
})

module.exports = router

