hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1.0",
    transform = 0,
})

for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), persistent = false })
end
