extends CanvasLayer

# Reference to the label node
var time_scale_label: Label

func _ready():
    # Get the label node
    time_scale_label = $TimeScale
    # Initialize the label with the current time scale
    update_time_scale_label()
    
    # Start a timer to periodically update the time scale display
    var timer = Timer.new()
    timer.wait_time = 0.1 # Update every 0.1 seconds
    timer.one_shot = false
    timer.autostart = true
    timer.connect("timeout", Callable(self, "_on_timer_timeout"))
    add_child(timer)

func _on_timer_timeout():
    update_time_scale_label()

# Function to update the label text
func update_time_scale_label():
    time_scale_label.text = "Time Scale: " + str(Engine.time_scale)
