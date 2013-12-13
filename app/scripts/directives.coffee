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

                
                scope.$watch('data', (newVal, oldVal) ->
                        scope.render(newVal)
                , true)


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
                                color = d3.scale.category20()
                                xScale = d3.scale.linear()
                                        .domain([0, d3.max( data, (d) -> d.rate ) ])
                                        .range([0, width])

                                svg.attr('height', height)



                                bars = svg.selectAll('rect')
                                        .data(data)
                                        .enter()
                                                .append('rect')
                                                .attr('height', barHeight)
                                                .attr('width', 140)
                                                .attr('x', Math.round(margin/2))
                                                .attr('y', (d,i) -> i * (barHeight + barPadding))
                                                .attr('fill', color(0))
                                                .transition()
                                                .duration(1000)
                                                .attr('width', (d) -> xScale(d.rate))
                                
                                labels = svg.selectAll('text')
                                        .data(data)
                                        .enter()
                                
                                # Site Description
                                labels.append('text')
                                        .text((d) -> d.site)
                                        .attr('x', Math.round(margin/2) + 5)
                                        .attr('y', (d,i) -> i * (barHeight + barPadding) + (barHeight - 5))
                                        .attr('fill', 'white' )
                                        .style('opacity', 0)
                                        .transition()
                                        .delay(500)
                                        .duration(500)
                                        .style('opacity', 1)

                                # Rate Description
                                labels.append('text')
                                        .text((d) -> d.rate)
                                        .attr('x', () -> 135 - this.getComputedTextLength())
                                        .attr('y', (d,i) -> i * (barHeight + barPadding) + (barHeight - 5))
                                        .attr('fill', 'white')
                                        .transition()
                                        .duration(1000)
                                        .attr('x',(d) -> xScale(d.rate) - this.getComputedTextLength() - 5)
