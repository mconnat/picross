local Case = {}

function Case:new(args)
    local instance = {}
    setmetatable(instance, { __index = Case })
    instance.X = args.x
    instance.Y = args.y
    instance.Width = args.width
    instance.Height = args.height
    instance.Checked = args.checked
    instance.Value = args.value
    instance.DrawMode = args.drawMode
    return instance
end

function Case:onClick()
    self.Checked = true
end

return Case
