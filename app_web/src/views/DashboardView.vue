<template>
  <div class="flexed-page">
    <div class="slider-container">
      <AppSlideBar />
    </div>
    <div class="main-content">
      <AppNavBar title="Dashboard" />
      <div class="page">
        <div class="top">
          <div class="top1">
            <v-card style="margin-bottom: 10px;">
              <v-col>
                Nombre total d'utilsateurs
              </v-col>
              <v-col class="num">
                {{ users.length }}
              </v-col>
            </v-card>
            <v-card style="margin-bottom: 10px;">
              <v-col>
                Nombre total de signalements
              </v-col>
              <v-col class="num">
                {{ anomalies.length }}
              </v-col>
            </v-card>
            <v-card>
              <v-col>
                Nombre total de signalements traités
              </v-col>
              <v-col class="num">
                {{ treated.length }}
              </v-col>
            </v-card>
            <v-card>
              <v-col>
                Nombre total de signalements traités haujourd'hui
              </v-col>
              <v-col class="num">
                {{ nbtraitement }}
              </v-col>
            </v-card>
          </div>
          <div class="top11">
            <v-card>
              <PieChart />
            </v-card>
          </div>
        </div>
        <div class="top2">
          <v-card>
            <BarChart />
          </v-card>
        </div>
        <div class="top3">
          <v-card>
            <LineChart/>
          </v-card>
        </div>
        <div class="top4">
          <v-card>
            <BarNumByMon />
          </v-card>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.flexed-page {
  height: 100%;
  display: flex;
}

.slider-container {
  height: 100%;
}

.main-content {
  width: 100%;
  height: 100%;
}

.page {
  margin: 10px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.top {
  display: flex;
  flex-direction: row;
  width: 100%;
  justify-content: space-between;
  margin-bottom: 15px;
}

.top1 {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-gap: 10px;
  width: 50%;
  text-transform: uppercase;
}

.top1 .num{
  font-size: 28px;
}

.top11 {
  width: 50%;
  margin-left: 10px;
}

.top2 {
  margin-bottom: 15px;
}

.top3 {
  margin-bottom: 15px;
}
</style>





<script>
import AppSlideBar from "../components/AppSlideBar";
import AppNavBar from "../components/AppNavBar.vue";
//charts
import PieChart from "../components/PieChart.vue";
import BarChart from "../components/BarChart.vue";
import LineChart from "../components/LineChart.vue";
import BarNumByMon from "../components/BarNumByMon.vue";

import supabase from "@/supabase";

export default {
  name: "dashboard",

  components: {
    AppSlideBar,
    AppNavBar,
    PieChart,
    BarChart,
    LineChart,
    BarNumByMon,
  },

  data() {
    return {
      users: [],
      anomalies: [],
      nbUtilisateurs: null,
      nbSignalements: null,
      treated: [],
      nbtraitement: null,
    }
  },

  mounted() {
    this.getUsers(),
    this.getAnomalies(),
    this.getTreated(),
    this.getAnomaliesTreatedToday()
  },

  methods: {
    async getUsers() {
      const { data, error } = await supabase.from('Utilisateurs').select();
      // console.log(data)
      if (error) {
        console.log(error)
      } else {
        this.users = data
        // console.log("successn lmmm")
      }
    },

    async getAnomalies() {
      const { data, error } = await supabase
        .from('signalement')
        .select('*')
      // console.log(data)
      if (error) {
        console.log(error)
      } else {
        this.anomalies = data
        // console.log("success jgjg")
      }
    },

    //write me a function that returns the number of anomalies where etat = traitée
    async getTreated() {
      const { data, error } = await supabase
        .from('signalement')
        .select('*')
        .eq('etat', 'traitée')
      // console.log(data)
      if (error) {
        console.log(error)
      } else {
        this.treated = data
        // console.log("success lglglgl")
      }
    },

    async getAnomaliesTreatedToday() {
      try {
        const { data, error } = await supabase.rpc('get_anomalies_treated_today');
        if (error) {
          console.error(error);
          return;
        }
        this.nbtraitement = data;
      } catch (error) {
        console.error(error);
      }
    },
  },
};
</script>