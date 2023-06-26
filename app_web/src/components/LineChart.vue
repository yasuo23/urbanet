<template>
  <div>
    <LineChartGenerator :chart-options="chartOptions" :chart-data="chartData" />
    <h4>Nombre d'anomalies par jour</h4>
  </div>
</template>

<script>
import { Line as LineChartGenerator } from 'vue-chartjs';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  LineElement,
  LinearScale,
  CategoryScale,
  PointElement
} from 'chart.js';
import supabase from "@/supabase";

ChartJS.register(Title, Tooltip, Legend, LineElement, LinearScale, CategoryScale, PointElement)

export default {
  name: 'LineChart',
  components: {
    LineChartGenerator
  },
  data() {
    return {
      chartData: {},
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false
      }
    }
  },

  mounted() {
    this.getData()
  },

  methods: {
    async getData() {
      const { data, error } = await supabase
        .from('anomalies_count_by_day')
        .select('*')

      // console.log(data)
      if (error) {
        console.error(error)
        return;
      }
      // console.log('ggggg')
      this.chartData = {
        labels: data.map(d => d.day.match(/\d{4}-\d{2}-\d{2}/)[0]),
        datasets: [
          {
            label: 'Number of Anomalies',
            backgroundColor: '#f87979',
            data: data.map(d => d.count)
          }
        ]
      };
    }
  }
}
</script>

<style scoped>
h4{
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>