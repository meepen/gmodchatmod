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

hook `ChatModInitialize`

called when the chat mod initializes (usually after someone opens chat)