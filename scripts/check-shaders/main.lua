-- Compiles every shader in ./shaders with the current renderer and exits with
-- the number of failures. Run via scripts/check-shaders.sh.
function love.load()
  local name, version = love.graphics.getRendererInfo()
  print(string.format("Renderer: %s %s", name, version))

  local failures = 0
  for _, file in ipairs(love.filesystem.getDirectoryItems "shaders") do
    if file:match "%.frag$" or file:match "%.vert$" or file:match "%.glsl$" then
      local ok, err = pcall(love.graphics.newShader, "shaders/" .. file)
      if ok then
        print("ok    " .. file)
      else
        failures = failures + 1
        print("FAIL  " .. file .. "\n" .. tostring(err))
      end
    end
  end

  print(string.format("%d shader(s) failed", failures))
  love.event.quit(failures)
end
