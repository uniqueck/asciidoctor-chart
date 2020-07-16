# frozen_string_literal: true

module Asciidoctor
  module Chart
    module Chartist
      class ChartBuilder
        def self.bar data, labels, attrs
          chart_id = get_chart_id
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_bar_script chart_id, data, labels, attrs
          to_html chart_div, chart_generate_script
        end

        def self.line data, labels, attrs
          chart_id = get_chart_id
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_line_script chart_id, data, labels, attrs
          to_html chart_div, chart_generate_script
        end

        def self.create_chart_div chart_id
          %(<div id="#{chart_id}"class="ct-chart"></div>)
        end

        def self.get_chart_id
          # TODO Read from attributes ?
          'chart' + PlainRubyRandom.uuid
        end

        def self.prepare_data raw_data
          labels = raw_data[0]
          raw_data.shift
          return raw_data, labels
        end

        def self.chart_bar_script chart_id, data, labels, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          <<~EOS
          <script>
          var options = {
            height: '#{chart_height}',
            colors: ["#72B3CC", "#8EB33B"]
          };
          var data = {
            labels: #{labels.to_s},
            series: #{data.to_s}
          };
          new Chartist.Bar('##{chart_id}', data, options);
          </script>
          EOS
        end

        def self.chart_line_script chart_id, data, labels, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          <<~EOS
          <script>
          var options = {
            height: '#{chart_height}',
            width: '#{chart_width}',
            colors: ["#72B3CC", "#8EB33B"]
          };
          var data = {
            labels: #{labels.to_s},
            series: #{data.to_s}
          };
          new Chartist.Line('##{chart_id}', data, options);
          </script>
          EOS
        end

        def self.to_html chart_div, chart_script
          <<~EOS
          #{chart_div}
          #{chart_script}
          EOS
        end

        def self.get_chart_height attrs
          (attrs.key? 'height') ? attrs['height'] : '400'
        end

        def self.get_chart_width attrs
          (attrs.key? 'width') ? attrs['width'] : '600'
        end
      end
    end
  end
end
