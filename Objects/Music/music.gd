extends AudioStreamPlayer

const level_music = preload("res://Music/Song.wav")
const title_music = preload("res://Music/Lightweight_Main_Theme.wav")

func _play_music(music: AudioStream, volume = -6.0):
	if stream == music && playing:
		return
		
	stream = music
	volume_db = volume
	play()
	
func play_music_level():
	_play_music(level_music)
	
func play_title_music():
	_play_music(title_music, 0.0)

func stop_music():
	stop()
	
