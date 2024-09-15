if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

require("utils")
Maps = require("maps")
Grid = require("Grid")
Config = require("Config")
Button = require("Button")

function love.load()
    OPTIONS = Config:new(
        {
            DEBUG = false,
            WindowWidth = 1280,
            WindowHeight = 1024,
            MinWindowWidth = 800,
            MinWindowHeight = 600
        })


    love.window.setMode(OPTIONS.WindowWidth, OPTIONS.WindowHeight,
        {
            resizable = true,
            vsync = 0,
            minwidth = OPTIONS.MinWindowWidth,
            minheight = OPTIONS.MinWindowHeight,
        }
    )

    OPTIONS:setFontSize(25)
    DisplayHeight = love.graphics.getHeight()
    DisplayWidth = love.graphics.getWidth()

    -- Create select map button list
    SelectionGridButtons = {}
    Grids = {}
    for k, map in ipairs(Maps) do
        table.insert(SelectionGridButtons, Button:new(map.Name))
        table.insert(Grids, Grid:new({ bitmap = map.Bitmap, squaresSize = map.SquaresSize, name = map.Name }))
    end

    -- Set Default grid
    local mapIndex = 1
    SelectionGridButtons[mapIndex].Selected = true

    SelectedGrid = {
        Name = SelectionGridButtons[mapIndex].DisplayText
    }
end

function love.resize(w, h)
    DisplayHeight = h
    DisplayWidth = w
end

function love.update(dt)
    for i = 1, #Grids do
        if Grids[i].Name == SelectedGrid.Name then
            SelectedGrid.Grid = Grids[i]
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        CheckMouseCollision(x, y)
    end
end

function love.draw()
    OPTIONS:setFontSize(25)
    DrawMapSelectionButtons()
    SelectedGrid.Grid:draw()


    if OPTIONS.DEBUG then
        OPTIONS:setFontSize(15)
        DebugString = "--- DEBUG ----"
        DebugString = DebugString .. "\nDisplayWidth: " .. DisplayWidth
        DebugString = DebugString .. "\nDisplayHeight: " .. DisplayHeight
        DebugString = DebugString .. "\nSelected Map: " .. SelectedGrid.Name
        DebugString = DebugString .. "\nCOLUMN (width): " .. SelectedGrid.Grid.GridWidth
        DebugString = DebugString .. "\nROW (height): " .. SelectedGrid.Grid.GridHeight
        DebugString = DebugString .. "\npixelWidth: " .. SelectedGrid.Grid.PixelWidth
        DebugString = DebugString .. "\npixelHeight: " .. SelectedGrid.Grid.PixelHeight
        love.graphics.print(DebugString, 0, 0)
    end
end
