<template>
  <div class="pie">
    <Pie :chart-options="chartOptions" :chart-data="chartData"/>
    <h4>Nombre d'anomalies par état</h4>
  </div>
</template>

<script>
import { Pie } from 'vue-chartjs'
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  ArcElement,
  CategoryScale
} from 'chart.js'
import supabase from "@/supabase";

ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale)

export default {
  name: 'PieChart',
  components: {
    Pie
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
        .from('anomalies_count_by_state')
        .select('*')

      // console.log(data)
      if (error) {
        console.error(error)
        return;
      }
      this.chartData = {
        labels: data.map(d => d.etat),
        datasets: [
          {
            backgroundColor: ['#E46651', '#41B883', '#FF0000', '#ec6206'],
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