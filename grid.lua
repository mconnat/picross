require("utils")
Case = require("Case")
local Grid = {}

function Grid:new(args)
    local instance = {}
    setmetatable(instance, { __index = Grid })

    instance.Bitmap = args.bitmap
    instance.GridHeight = #args.bitmap
    instance.GridWidth = #args.bitmap[1]
    instance.PixelWidth = args.squaresSize * instance.GridWidth
    instance.PixelHeight = args.squaresSize * instance.GridHeight
    instance.LineHints = {}
    instance.ColumnHints = {}
    instance.SquaresSize = args.squaresSize
    instance.Name = args.name
    instance.GridInfo = nil
    instance:_generateGrid()
    instance:_generateHints()
    return instance
end

function Grid:_generateHints()
    for i = 1, self.GridHeight do
        self.LineHints[i] = CompteSeries(self.Bitmap[i])
    end
    for i = 1, self.GridWidth do
        local tmpColumn = {}
        for j = 1, self.GridHeight do
            table.insert(tmpColumn, self.Bitmap[j][i])
        end
        self.ColumnHints[i] = CompteSeries(tmpColumn)
    end
end

function Grid:_generateGrid()
    local GridInfo = {}
    for i = 1, #self.Bitmap do
        local line = {}
        for j = 1, #self.Bitmap[i] do
            local case = Case:new({
                x = ((DisplayWidth / 2 + ((j - 1) * self.SquaresSize)) - self.PixelWidth / 2),
                y = ((DisplayHeight / 2 + ((i - 1) * self.SquaresSize)) - self.PixelHeight / 2),
                width = self.SquaresSize,
                height = self.SquaresSize,
                checked = false,
                value = self.Bitmap[i][j],
                drawMode = "line"
            })
            table.insert(line, case)
        end
        table.insert(GridInfo, line)
    end
    self.GridInfo = GridInfo
end

function Grid:draw()
    local r, g, b, a = love.graphics.getColor()
    for i = 1, #self.GridInfo do
        for j = 1, #self.GridInfo[i] do
            love.graphics.setColor(r, g, b, a)
            -- Draw grid Case wire
            love.graphics.rectangle(
                self.GridInfo[i][j].DrawMode,
                self.GridInfo[i][j].X,
                self.GridInfo[i][j].Y,
                self.GridInfo[i][j].Width,
                self.GridInfo[i][j].Height,
                0,
                0
            )
            -- Draw grid Case if filled
            if self.GridInfo[i][j].DrawMode == "fill" then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle(
                    self.GridInfo[i][j].DrawMode,
                    self.GridInfo[i][j].X - 1,
                    self.GridInfo[i][j].Y - 1,
                    self.GridInfo[i][j].Width - 1,
                    self.GridInfo[i][j].Height - 1,
                    0,
                    0
                )
                love.graphics.setColor(r, g, b, a)
            end
            -- if grid case is checked and the value is 1, fill the case
            -- -- if DEBUG is true, display a green square in the top right corner of the case
            if self.GridInfo[i][j].Value == 1 and self.GridInfo[i][j].Checked == true then
                if OPTIONS.DEBUG then
                    love.graphics.setColor(0, 0.5, 0, 0.5)
                    love.graphics.rectangle(
                        "fill",
                        self.GridInfo[i][j].X + (self.SquaresSize * 0.1),
                        self.GridInfo[i][j].Y + (self.SquaresSize * 0.1),
                        self.GridInfo[i][j].Width * 0.2,
                        self.GridInfo[i][j].Height * 0.2,
                        0,
                        0
                    )
                    love.graphics.setColor(r, g, b, a)
                end
                self.GridInfo[i][j].DrawMode = "fill"
            end
            -- if grid case is checked and the value is 0, display a red square in the top right corner of the case
            -- Helps to keep track of wrong answer
            if self.GridInfo[i][j].Value == 0 and self.GridInfo[i][j].Checked == true then
                love.graphics.setColor(1, 0, 0, 0.8)
                love.graphics.rectangle(
                    "fill",
                    self.GridInfo[i][j].X + (self.SquaresSize * 0.1),
                    self.GridInfo[i][j].Y + (self.SquaresSize * 0.1),
                    self.GridInfo[i][j].Width * 0.2,
                    self.GridInfo[i][j].Height * 0.2,
                    0,
                    0
                )
                love.graphics.setColor(r, g, b, a)
            end
            -- Draw column Hints
            if self.ColumnHints[j] then
                for index = 1, #self.ColumnHints[j] do
                    local color = (index / 2) * 0.5
                    love.graphics.setColor(color, color, color, 1)
                    local font = love.graphics.getFont()
                    local fontWidth = font:getWidth(self.ColumnHints[j][index])
                    local fontHeight = font:getHeight(self.ColumnHints[j][index])

                    local x = self.GridInfo[1][j].X + (self.SquaresSize / 2)
                    local y = self.GridInfo[1][j].Y - (index * self.SquaresSize)
                    local value = self.ColumnHints[j][#self.ColumnHints[j] - index + 1]
                    love.graphics.print(value, x, y, 0, 1, 1, fontWidth / 2,
                        fontHeight / 2)
                end
            end
        end
        -- Draw line Hints
        if self.LineHints[i] then
            for index = 1, #self.LineHints[i] do
                local color = (index / 2) * 0.5
                love.graphics.setColor(color, color, color, 1)
                local font = love.graphics.getFont()
                local fontWidth = font:getWidth(self.LineHints[i][index])
                local fontHeight = font:getHeight(self.LineHints[i][index])
                local x = (self.GridInfo[i][1].X - (index * self.SquaresSize))
                local y = self.GridInfo[i][1].Y + (self.SquaresSize / 2)

                love.graphics.print(self.LineHints[i][#self.LineHints[i] - index + 1], x, y, 0, 1, 1, fontWidth / 2,
                    fontHeight / 2)
            end
        end

        love.graphics.setColor(r, g, b, a)
    end
    love.graphics.setColor(r, g, b, a)
end

return Grid
