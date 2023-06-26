<template>
    <div>
        <v-select class="pf" placeholder="type" v-model="selectedType" :items="liste"></v-select>
        <v-btn class="pf" @click="getData()">Get Data</v-btn>
        <Bar :chart-options="chartOptions" :chart-data="chartData" />
    </div>
</template>

<style>
.pf {
    width: 200px;
    margin-bottom: 20px;
    margin-left: 20px;
}
</style>

<script>
import { Bar } from 'vue-chartjs';

import {
    Chart as ChartJS,
    Title,
    Tooltip,
    Legend,
    BarElement,
    CategoryScale,
    LinearScale
} from 'chart.js';

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

import supabase from '@/supabase';

export default {
    name: 'BarNumByMon',
    components: {
        Bar
    },

    data() {
        return {
            chartData: {},
            chartOptions: {
                responsive: true,
                maintainAspectRatio: false
            },
            selectedType: '',
            liste: [
                'fuite d eau',
                'ordure abondonnée',
                'nid de poule',
                'débris de verre',
                'route déformé',
                'égout bouchée',
                'ordure abondonnée',
                'Autre'
            ]
        };
    },

    mounted() {
        this.initBar();
    },

    methods: {
        async getData() {
            if (this.selectedType) {
                try {
                    const { data } = await supabase.rpc('get_anomalies_count_by_month', {
                        type_param: this.selectedType
                    });

                    this.chartData = {
                        labels: data.map(item => item.year_month),
                        datasets: [{
                            label: 'Anomalies Count',
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1,
                            data: data.map(item => item.total_anomalies)
                        }]
                    };
                } catch (error) {
                    console.error('Error fetching anomalies data:', error);
                }
            } else {
                this.chartData = {};
            }
        },

        initBar() {
            // init chart with 0's
            this.chartData = {
                labels: [
                    'Janvier',
                    'Février',
                    'Mars',
                    'Avril',
                    'Mai',
                    'Juin',
                    'Juillet',
                    'Août',
                    'Septembre',
                    'Octobre',
                    'Novembre',
                    'Décembre'
                ],
                datasets: [{
                    label: 'Anomalies Count',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1,
                    data: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                }]
            };
        }
    }
};
</script>
