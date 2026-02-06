extends Node

var reachy_present: bool = false
var http: HTTPRequest
var pending_request: bool = false
var reachy_ip: String

signal next_text

var scores = [0, 0]
var current_text_file = 0
var conversations_size: int

func disconnect_next_text():
	print(next_text.get_connections().size())
	for connection in next_text.get_connections():
		next_text.disconnect(connection["callable"])

func init_reachy():
	if reachy_present:
		http.request_completed.connect(_on_request_completed)
		envia_reachy("welcoming1")

func envia_reachy(_emoji: String):
	if reachy_present and not pending_request:
		http.request("http://"+reachy_ip+":8000/api/move/play/recorded-move-dataset/pollen-robotics/reachy-mini-emotions-library/"+_emoji, [], HTTPClient.METHOD_POST)
		pending_request = true
	
func _on_request_completed(_result, _response_code, _headers, _body):
	pending_request = false
	if _response_code >= 400:
		print("can't reach reachy %d" % _response_code)
