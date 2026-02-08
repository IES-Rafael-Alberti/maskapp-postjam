extends Node

var reachy_present: bool = false
var http: HTTPRequest
var pending_request: bool = false
var reachy_ip: String

# OpenRouter LLM
var openrouter_present: bool = false
var openrouter_api_key: String
var openrouter_model: String
var openrouter_prompt: String
var http_openrouter: HTTPRequest
var pending_emoji: String
var emojis_positivos = ["yes1", "loving1", "cheerful1", "laughing1", "enthusiastic1", "helpful2", "welcoming2", "surprised2", "confused1"]

signal next_text

var scores = [0, 0]
var current_text_file = 0
var conversations_size: int

func disconnect_next_text():
	#print(next_text.get_connections().size())
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
		reachy_present = false
		print("can't reach reachy %d" % _response_code)

# OpenRouter functions
func init_openrouter():
	if FileAccess.file_exists("res://config/openrouter.cfg"):
		var config = ConfigFile.new()
		var err = config.load("res://config/openrouter.cfg")
		if err == OK:
			openrouter_api_key = config.get_value("openrouter", "api_key", "")
			openrouter_model = config.get_value("openrouter", "model", "openai/gpt-4o-mini")
			if openrouter_api_key != "" and openrouter_api_key != "TU_API_KEY_AQUI":
				openrouter_present = true
				# Cargar prompt
				if FileAccess.file_exists("res://text/prompts/seguridad.txt"):
					var file = FileAccess.open("res://text/prompts/seguridad.txt", FileAccess.READ)
					openrouter_prompt = file.get_as_text()
				# Crear HTTPRequest para OpenRouter
				http_openrouter = HTTPRequest.new()
				http_openrouter.request_completed.connect(_on_openrouter_completed)
				# Se añade al árbol en game.gd después de init
				print("[LLM] OpenRouter inicializado con modelo: %s" % openrouter_model)

func evaluar_coherencia(texto: String, emoji: String):
	if not openrouter_present:
		envia_reachy(emoji)
		return

	pending_emoji = emoji
	var valoracion = "POSITIVO" if emoji in emojis_positivos else "NEGATIVO"

	var prompt_final = openrouter_prompt.replace("{TEXTO}", texto).replace("{VALORACION}", valoracion)

	print("[LLM] Entrada: texto='%s', valoracion='%s'" % [texto, valoracion])

	var headers = [
		"Authorization: Bearer " + openrouter_api_key,
		"Content-Type: application/json"
	]
	var body = {
		"model": openrouter_model,
		"messages": [{"role": "user", "content": prompt_final}]
	}

	http_openrouter.request("https://openrouter.ai/api/v1/chat/completions", headers, HTTPClient.METHOD_POST, JSON.stringify(body))

func _on_openrouter_completed(_result, response_code, _headers, body):
	if response_code >= 400:
		print("[LLM] Error en OpenRouter: %d" % response_code)
		print("[REACHY] Reacción (fallback): %s" % pending_emoji)
		envia_reachy(pending_emoji)
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	if json == null or not json.has("choices"):
		print("[LLM] Respuesta inválida")
		print("[REACHY] Reacción (fallback): %s" % pending_emoji)
		envia_reachy(pending_emoji)
		return

	var respuesta = json["choices"][0]["message"]["content"]
	print("[LLM] Respuesta: %s" % respuesta)

	var emoji_final = pending_emoji
	if respuesta.find("<juicio>MAL</juicio>") != -1:
		emoji_final = "furious1"

	print("[REACHY] Reacción: %s" % emoji_final)
	envia_reachy(emoji_final)
