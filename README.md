# Garry's Mod Chat Mod

Garry's Mod Chat Mod mod is a light-weight solution to creating a new chat box. It works internally within source engine so it doesn't look hacky and feel like it too.

# API

`chat.Resize(w,h)`

Sets the chat box to width w and height h


`chat.GetFilterButton()`

Gets the filter button panel


`chat.GetPanel()`

Gets the main panel


`chat.GetInput()`

Gets the input text area


`chat.GetInputLine()`

Gets the input text area's parent


`chat.GetHistory()`

Gets the text history box (where you see other's chat messages)


`chat.SetFont(fontname)`

Sets all the text in the chat panel to fontname font.


`chat.IsActive()`

Returns if the player is able to type

`chat.IsOpen()`

Returns if chat is open

`chat.IsTyping()`

Returns if the keyboard focus is the input box


#History panel functions


`chat.Append(text)`

Appends `text` to the history panel

`chat.SetColor(color)`

Sets the color for upcoming `chat.Append(text)`

`chat.InsertClickableText(id)`
`chat.EndClickableText()`

Used for clickable text (broken?) Check the garrysmod wiki.

`chat.InsertStandardFade()`

Inserts the standard fade for upcoming text from `chat.Append`


#Hooks


hook `ChatModInitialize`

called when the chat mod initializes (usually after someone opens chat)

hook `ChatResized`

called when chat is resized with `chat.Resize`