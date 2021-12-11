local RouterContext = require(script.Parent.RouterContext)

local function useLocation(hooks)
	local context = hooks.useContext(RouterContext)
	return context.history.location
end

return useLocation