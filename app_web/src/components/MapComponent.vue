<template>
    <div>
        <l-map :center="mapCenter" :zoom="zoomLevel" class="map" ref="map" @update:mapCenter="centerUpdated"
            @update:zoomLevel="zoomUpdated">
            <l-tile-layer :url="url"></l-tile-layer>
            <!-- <l-marker v-for="(anomaly, index) in anomalies" :key="index" :lat-lng="locationLatLng(anomaly)">
                <l-popup>
                    <div>
                        <h3>Anomaly Type: {{ anomaly.type }}</h3>
                        <h3>Anomaly State: {{ anomaly.etat }}</h3>
                    </div>
                </l-popup>
            </l-marker> -->
            <l-marker v-for="(anomaly, index) in anomalies" :key="index" :lat-lng="[anomaly.lat, anomaly.lon]">
                <l-popup>
                    <div>
                        <h3>Anomaly Type: {{ anomaly.type }}</h3>
                        <h3>Anomaly State: {{ anomaly.etat }}</h3>
                    </div>
                </l-popup>
            </l-marker>
        </l-map>
    </div>
</template>

<script>
import supabase from '../supabase.js'
import { LMap, LTileLayer, LMarker, LPopup } from 'vue2-leaflet';
import 'leaflet/dist/leaflet.css';
import { Icon } from 'leaflet';
import { parse } from 'wellknown'

delete Icon.Default.prototype._getIconUrl;
Icon.Default.mergeOptions({
    iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
    iconUrl: require('leaflet/dist/images/marker-icon.png'),
    shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});
export default {
    name: 'theMap',
    components: {
        LMap,
        LTileLayer,
        LMarker,
        LPopup
    },
    data() {
        return {
            mapCenter: [36.740494, 3.005074],
            zoomLevel: 10,
            url: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            anomalies: [],
        }
    },


    mounted() {
        this.getAnomalies();
    },

    methods: {
        centerUpdated(newCenter) {
            this.mapCenter = newCenter;
        },

        zoomUpdated(newZoom) {
            this.zoomLevel = newZoom;
        },

        async getAnomalies() {
            const { data, error } = await supabase
                .from('signalement')
                .select('*');
            if (error) {
                console.log(error)
            } else {
                this.anomalies = data
                console.log("success")
                console.log(this.anomalies)
            }
        },

        // locationLatLng(anomaly) {
        //     try {
        //         const geometry = parse(anomaly.location);
        //         if (geometry && geometry.coordinates && geometry.coordinates.length >= 2) {
        //             const latitude = geometry.coordinates[1];
        //             const longitude = geometry.coordinates[0];
        //             return [latitude, longitude];
        //         } else {
        //             console.log('Invalid geometry:', anomaly.location);
        //             return [0, 0]; // Default coordinates or any other fallback value you prefer
        //         }
        //     } catch (error) {
        //         console.log('Parsing error:', error);
        //         return [0, 0]; // Default coordinates or any other fallback value you prefer
        //     }
        // }





    }
}
</script>

<style scoped>
.map {
    height: 80vh;
    width: 100%;
    margin: 15px;
}
</style>