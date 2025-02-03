extends Node
## Manager of audio buses data and global audio streams playback. 

#region Signals
#endregion Signals

#region Enums
## TODO
enum AudioBus {
	MASTER,
	SFX,
	MUSIC,
	DIALOGUE,
}
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var multiple_global_sound_playback    : bool = false
## TODO
@export var multiple_global_music_playback    : bool = false
## TODO
@export var multiple_global_dialogue_playback : bool = false
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _buses_dictionary : Dictionary = {
	AudioBus.MASTER: {
		"index":         -1,
		"name":    "Master",
	},
	AudioBus.SFX: {
		"index":         -1,
		"name":       "SFX",
	},
	AudioBus.MUSIC: {
		"index":         -1,
		"name":     "Music",
	},
	AudioBus.DIALOGUE: {
		"index":         -1,
		"name":  "Dialogue",
	},
}
#endregion Private Variables

#region On Ready Variables
@onready var _sfx_stream_player      : AudioStreamPlayer = %SFXStreamPlayer
@onready var _music_stream_player    : AudioStreamPlayer = %MusicStreamPlayer
@onready var _dialogue_stream_player : AudioStreamPlayer = %DialogueStreamPlayer
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	for bus in _buses_dictionary.keys():
		_buses_dictionary[bus].index = AudioServer.get_bus_index(_buses_dictionary[bus].name)
	
	_assert_buses_availability()
#endregion Built-in Virtual Methods

#region Public Methods
#region Buses
## TODO
func get_buses() -> Array[AudioBus]:
	return _buses_dictionary.keys()
## TODO
func get_bus_name(bus : AudioBus) -> String:
	return _buses_dictionary[bus].name
## TODO
func get_bus_volume(bus : AudioBus) -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(_buses_dictionary[bus].index))
## TODO
func get_bus_mute_state(bus : AudioBus) -> bool:
	return AudioServer.is_bus_mute(_buses_dictionary[bus].index)
## TODO
func set_bus_volume(bus : AudioBus, volume_factor : float) -> void:
	volume_factor = clampf(volume_factor, 0.0, 1.0)
	AudioServer.set_bus_volume_db(_buses_dictionary[bus].index, linear_to_db(volume_factor))
## TODO
func increase_bus_volume(bus : AudioBus, delta_volume_factor : float) -> void:
	set_bus_volume(bus, get_bus_volume(bus) + delta_volume_factor)
## TODO
func decrease_bus_volume(bus : AudioBus, delta_volume_factor : float) -> void:
	increase_bus_volume(bus, -delta_volume_factor)
## TODO
func set_bus_mute_state(bus : AudioBus, value : bool) -> void:
	AudioServer.set_bus_mute(_buses_dictionary[bus].index, value)
## TODO
func toggle_bus_mute_state(bus : AudioBus) -> void:
	set_bus_mute_state(bus, not get_bus_mute_state(bus))
#endregion Buses
#region Playback
## TODO
func play_sound(audio_stream : AudioStream) -> void:
	if not multiple_global_sound_playback:
		if _sfx_stream_player.playing:
			LogManager.audio_log("Trying to play sound while another is already playing, overriding")
		_sfx_stream_player.stream = audio_stream
		_sfx_stream_player.play()
		LogManager.audio_log("Playing sound %s" % audio_stream.resource_path)
	else:
		pass
## TODO
func play_music(audio_stream : AudioStream) -> void:
	pass
## TODO
func play_dialogue(audio_stream : AudioStream) -> void:
	pass
#endregion Playback
#endregion Public Methods

#region Private Methods
func _assert_buses_availability() -> void:
	for bus in _buses_dictionary.keys():
		assert(_buses_dictionary[bus].index != -1)
#endregion Private Methods
