local Config = {}

function Config:new(args)
    local instance = {}
    setmetatable(instance, { __index = Config })
    instance.DEBUG = args.DEBUG
    instance.WindowWidth = args.WindowWidth
    instance.WindowHeight = args.WindowHeight
    instance.MinWindowWidth = args.MinWindowWidth
    instance.MinWindowHeight = args.MinWindowHeight
    instance.Font = love.graphics.newFont("assets/Harvest Yard.otf", 25)

    return instance
end

function Config:setFontSize(size)
    self.Font = love.graphics.newFont("assets/Harvest Yard.otf", size)
    love.graphics.setFont(OPTIONS.Font)
end

return Config
