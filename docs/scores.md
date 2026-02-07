# Sistema de Puntuación

## Fórmula

```
puntuación = suma(segundos_meca) + int(suma(segundos_libre) × emoji_mult)
```

## Mecánicas

### Mecanografía (`%texto%`)

- Aparece contador de 20 segundos sobre el mensaje.
- El jugador debe escribir exactamente el texto mostrado.
- Al completar, los segundos restantes (redondeados a entero) se suman directamente a la puntuación.
- El timer se reinicia a 20 segundos para el siguiente campo.

### Escritura libre (`_texto_`)

- Mismo contador de 20 segundos.
- El jugador escribe lo que quiera en el espacio.
- Al completar, los segundos restantes se acumulan.
- Al final del bocadillo, la suma de segundos de todos los campos libres se multiplica por el emoji seleccionado.

## Multiplicadores de emoji

| Emoji | Nombre | Multiplicador |
|-------|--------|---------------|
| 👍 | yes1 | x1.5 |
| ❤️ | loving1 | x2.0 |
| 😁 | cheerful1 | x1.6 |
| 😂 | laughing1 | x2.0 |
| 😢 | downcast1 | x-1.5 |
| ☺️ | enthusiastic1 | x1.2 |
| 🙏 | helpful2 | x1.0 |
| 😇 | welcoming2 | x1.0 |
| 😮 | surprised2 | x1.3 |
| 😅 | laughing2 | x0.9 |
| 🤯 | confused1 | x2.1 |
| 👎 | no1 | x-2.0 |

## Ejemplo

Bocadillo: `Hola %meca1% qué tal _libre1_ bien %meca2%`

1. Completa meca1 con 15.7s restantes → meca_score += 15
2. Timer reinicia a 20s
3. Completa libre1 con 12.3s restantes → libre_score += 12.3
4. Timer reinicia a 20s
5. Completa meca2 con 18.2s restantes → meca_score += 18
6. Selecciona emoji loving1 (x2.0)
7. Puntuación: `15 + 18 + int(12.3 × 2.0) = 15 + 18 + 24 = 57`

## Notas

- Los campos vacíos simplemente no aportan puntos (no hay penalización)
- Los campos de mecanografía y escritura libre son independientes
- Los emojis negativos pueden dar puntuación negativa en la parte de escritura libre
- Cada campo tiene su propio timer de 20 segundos que se reinicia al pasar al siguiente
