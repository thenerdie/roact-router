local Roact = require(script.Parent.Roact)

local RouteContext = require(script.Parent.RouteContext)
local Path = require(script.Parent.Path)
local withRouter = require(script.Parent.withRouter)
local merge = require(script.Parent.merge)
local getComponentName = require(script.Parent.getComponentName)

local Route = Roact.Component:extend("Route")

Route.defaultProps = {
	path = "/",
	alwaysRender = false,
	exact = false,
}

function Route.getDerivedStateFromProps(props)
	return {
		path = Path.new(props.path),
	}
end

function Route:willUnmount()
	self.listener:disconnect()
end

function Route:render()
	local context = self.props.context
	
	local routeProps = {
		match = self.state.path:match(context.location.path, self.props),
		location = context.history.location,
		history = context.history,
	}

	local element

	if self.props.alwaysRender or routeProps.match then
		if self.props.render then
			element = self.props.render(routeProps)
		elseif self.props.component then
			element = Roact.createElement(self.props.component, routeProps)
		else
			element = Roact.createFragment(self.props[Roact.Children])
		end
	end

	return Roact.createElement(RouteContext.Provider, {
		value = routeProps,
	}, {
		[element and getComponentName(element.component) or "nil"] = element,
	})
end

local function RouteWrapper(props)
	return withRouter(function(router)
		return Roact.createElement(Route, merge(props, {
			context = router,
		}))
	end)
end

return RouteWrapper