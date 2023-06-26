<template>
  <div>
    <Bar :chart-options="chartOptions" :chart-data="chartData"/>
    <h4>Nombre d'anomalies par type</h4>
  </div>
</template>
  
<script>
import { Bar } from 'vue-chartjs'

import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
} from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

import supabase from "@/supabase";

export default {
  name: 'BarChart',
  components: {
    Bar
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
        .from('anomalies_count_by_type')
        .select('*')
      // console.log(data)
      if (error) {
        console.error(error)
        return;
      }
      const labels = data.map(row => row.type)
      const counts = data.map(row => row.count)
      this.chartData = {
        labels,
        datasets: [
          {
            label: 'Anomalies type',
            backgroundColor: ['#7393B3'],
            data: counts
          }
        ]
      };
    }
  },
}
</script>

<style scoped>
h4{
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>