directives = angular.module 'app'
directives.directive 'd3Bars', ($window,$timeout, $log) ->
        restrict: 'EA'
        scope: 
                data: '='
        link: (scope, element, attrs) ->
                renderTimeout = null
                margin = parseInt attrs.margin || 20
                barHeight = parseInt attrs.barHeight || 20
                barPadding = parseInt attrs.barPadding || 5
                maxTextLength = 0;

                svg = d3.select(element[0])
                        .append('svg')
                        .style('width', '100%')

                $window.onresize = ->
                        scope.$apply()

                # watch for value change on scope.data
                scope.$watch('data', (newVal, oldVal) ->
                        scope.render(newVal)
                , true)


                # watch for window resize and re-render
                scope.$watch ->
                        return angular.element($window)[0].innerWidth
                , -> 
                        scope.render(scope.data)

                scope.render = (data) ->
                        
                        svg.selectAll('*').remove()

                        return if !data
                        if renderTimeout
                                clearTimeout(renderTimeout)

                        renderTimeout = $timeout ->
                                width = d3.select(element[0])[0][0].offsetWidth - margin
                                height = scope.data.length * (barHeight + barPadding)
                                colors = d3.scale.category20()
                                xScale = d3.scale.linear()
                                        .domain([0, d3.max( data, (d) -> d.rate ) ])
                                        .range([0, width])

                                svg.attr('height', height)


                                groups = svg.selectAll('g')
                                        .data(data)
                                        .enter()
                                bars = groups.append('rect')
                                        .on('mouseover', ->
                                                d3.select(this)
                                                .attr('fill', '#F08080')
                                        )
                                        .on('mouseout', ->
                                                d3.select(this)
                                                .attr('fill', (d,i) -> colors 0 )
                                        )
                                        .attr('height', barHeight)
                                        .attr('width', 140)
                                        .attr('x', Math.round(margin/2))
                                        .attr('y', (d,i) -> i * (barHeight + barPadding))
                                        .attr('fill', colors(0))
                                        .transition()
                                        .duration(1000)
                                        .attr('width', (d) -> xScale(d.rate))

                                
                                
                                # Site Description
                                groups.append('text')
                                        .text((d) -> d.site)
                                        .attr('x', Math.round(margin/2) + 5)
                                        .attr('y', (d,i) -> i * (barHeight + barPadding) + (barHeight - 5))
                                        .attr('fill', 'white' )
                                        .style('opacity', 0)
                                        .style('pointer-events','none')
                                        .transition()
                                        .delay(500)
                                        .duration(500)
                                        .style('opacity', 1)

                                # Rate Description
                                groups.append('text')
                                        .text((d) -> d.rate)
                                        .attr('x', () -> 135 - this.getComputedTextLength())
                                        .attr('y', (d,i) -> i * (barHeight + barPadding) + (barHeight - 5))
                                        .attr('fill', 'white')
                                        .style('pointer-events','none')
                                        .transition()
                                        .duration(1000)
                                        .attr('x',(d) -> xScale(d.rate) - this.getComputedTextLength() - 5)
