local Button = {}

function Button:new(text)
    local instance = {}
    setmetatable(instance, { __index = Button })
    instance.DrawMode = "line"
    instance.Selected = false
    if text ~= nil then
        instance.DisplayText = text
    else
        instance.DisplayText = ""
    end
    instance.X = 0
    instance.Y = 0
    instance.Width = 0
    instance.Height = 0
    instance.RoundRadiusX = 20
    instance.RoundRadiusY = 20

    return instance
end

function Button:draw()
    local r, g, b, a = love.graphics.getColor() -- Get the actual color
    if self.Selected then
        self.DrawMode = "fill"
        love.graphics.setColor(0, 0.5, 0, 0.5) -- Change Color if btn selected
    else
        self.DrawMode = "line"
    end
    love.graphics.rectangle(
        self.DrawMode,
        self.X,
        self.Y,
        self.Width,
        self.Height,
        self.RoundRadiusX,
        self.RoundRadiusY
    )
    love.graphics.setColor(r, g, b, a) -- Change back to original color
    local font = love.graphics.getFont()
    local fontWidth = font:getWidth(self.DisplayText)
    local fontHeight = font:getHeight(self.DisplayText)
    love.graphics.print(
        self.DisplayText,
        self.X + (self.Width / 2),
        self.Y + (self.Height / 2),
        0,
        1,
        1,
        fontWidth / 2,
        fontHeight / 2
    )
end

function Button:onClick()
    for i = 1, #SelectionGridButtons do
        SelectionGridButtons[i].Selected = false
    end
    self.Selected = true
    SelectedGrid.Name = self.DisplayText
end

return Button
