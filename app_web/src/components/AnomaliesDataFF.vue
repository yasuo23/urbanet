<template>
    <div>
        <v-data-table :headers="headers" :items="anomalies" item-key="ids">
            <template v-for="(col, i) in filters" v-slot:[`header.${i}`]="{ header }">
                <div style="display: inline-block; padding: 16px 0;">{{ header.text }}</div>
                <div style="float: right; margin-top: 8px">
                    <v-menu :close-on-content-click="false" :nudge-width="200" offset-y transition="slide-y-transition" left
                        fixed style="position: absolute; right: 0">
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn color="indigo" icon v-bind="attrs" v-on="on">
                                <v-icon small
                                    :color="activeFilters[header.value] && activeFilters[header.value].length < filters[header.value].length ? 'red' : 'default'">
                                    mdi-filter-variant
                                </v-icon>
                            </v-btn>
                        </template>
                        <v-list flat dense class="pa-0">
                            <v-list-item-group multiple v-model="activeFilters[header.value]" class="py-2">
                                <template v-for="(item) in filters[header.value]">
                                    <v-list-item :value="item" :ripple="false" :key="item">
                                        <template v-slot:default="{ active, toggle }">
                                            <v-list-item-action>
                                                <v-checkbox :input-value="active" :true-value="item" @click="toggle"
                                                    color="primary" :ripple="false" dense></v-checkbox>
                                            </v-list-item-action>
                                            <v-list-item-content>
                                                <v-list-item-title>{{ item }}</v-list-item-title>
                                            </v-list-item-content>
                                        </template>
                                    </v-list-item>
                                </template>
                            </v-list-item-group>
                            <v-divider></v-divider>
                            <v-row no-gutters>
                                <v-col cols="6">
                                    <v-btn text block @click="toggleAll(header.value)" color="success">Toggle all</v-btn>
                                </v-col>
                                <v-col cols="6">
                                    <v-btn text block @click="clearAll(header.value)" color="warning">Clear all</v-btn>
                                </v-col>
                            </v-row>
                        </v-list>
                    </v-menu>
                </div>
            </template>
            <template v-slot:top>
                <v-toolbar flat>
                    <v-dialog v-model="dialogDetails" max-width="800px" class="d-flex align-center">
                        <v-card>
                            <v-card-title class="align-center">Details de l'anomalie</v-card-title>
                            <v-card-text>
                                <v-container class="d-flex">
                                    <v-col cols="6">
                                        <v-row class="det">
                                            ID : {{ anomaly.ids }}
                                        </v-row>
                                        <v-row class="det">
                                            Type : {{ anomaly.type }}
                                        </v-row>
                                        <v-row class="det">
                                            Date : {{ anomaly.DateS }}
                                        </v-row>
                                        <v-row class="det">
                                            Etat : <v-chip :color="etatColorMap[anomaly.etat]"> {{ anomaly.etat }}</v-chip>
                                        </v-row>
                                        <v-row class="det">
                                            Address : {{ anomaly.address }}
                                        </v-row>
                                        <v-row class="det">
                                            Description : {{ anomaly.description }}
                                        </v-row>
                                    </v-col>
                                    <v-col col="6">
                                        <v-carousel height="400px" style="width: 350px;">
                                            <v-carousel-item v-for="im in anomaly.images" :key="im" :src="im"
                                                width="100%"></v-carousel-item>
                                        </v-carousel>
                                    </v-col>
                                </v-container>
                            </v-card-text>
                        </v-card>
                    </v-dialog>
                    <v-dialog v-model="dialogEdit" max-width="700px">
                        <v-card>
                            <v-card-title class="align-center"> Modifier </v-card-title>
                            <v-card-text>
                                <v-container>
                                    <v-row>
                                        <v-col cols="4">Etat:</v-col>
                                        <v-col cols="8">
                                            <v-select placeholder="etat" v-model="updatedAnomaly.etat"
                                                :items="['traitée', 'en cours', 'refusée']"></v-select>
                                        </v-col>
                                    </v-row>
                                    <v-row>
                                        <v-btn primary @click="updateAnomaly(selectedId)">Modifier</v-btn>
                                    </v-row>
                                </v-container>
                            </v-card-text>
                        </v-card>
                    </v-dialog>
                    <v-dialog v-model="dialogDelete" max-width="500px">
                        <v-card>
                            <v-card-title class="align-center">Are you sure you want to delete this item?</v-card-title>
                            <v-card-actions class="rounded-xl">
                                <v-spacer></v-spacer>
                                <v-btn color="primary " text @click="closeDelete">Cancel</v-btn>
                                <v-btn color="primary " @click="deleteAnomaly(selectedId)">OK</v-btn>
                                <v-spacer></v-spacer>
                            </v-card-actions>
                        </v-card>
                    </v-dialog>
                </v-toolbar>
            </template>
            <template v-slot:[`item.etat`]="{ item }">
                <v-chip :color="etatColorMap[item.etat]">{{ item.etat }}</v-chip>
            </template>
            <template v-slot:[`item.actions`]="{ item }">
                <v-icon color="blue" size="22" @click="editItem(item.ids)"> mdi-pencil </v-icon>
                <v-icon color="red" size="22" @click="deleteItem(item.ids)"> mdi-delete </v-icon>
                <v-icon color="green" size="22" @click="showDetails(item.ids)">mdi-eye</v-icon>
            </template>
            <template v-slot:no-data>
                <h3 class="secondary--text">No DATA</h3>
            </template>
        </v-data-table>
    </div>
</template>

<script>
import supabase from '@/supabase.js';
import { set } from 'vue';
export default {
    name: 'anomaliesData',
    data() {
        return {
            dialogEdit: false,
            dialogDelete: false,
            dialogDetails: false,
            selectedId: null,
            filters: { 'type': [], 'etat': [], 'commune': [] },
            activeFilters: {},
            anomalies: [],
            anomaly: {
                ids: null,
                type: null,
                DateS: null,
                etat: null,
                description: null,
                images: null,
                lat: null,
                lon: null,
                address: null,
            },
            updatedAnomaly: {
                etat: null,
                foncitonnaire: null,
                DateT: new Date().toISOString().split('T')[0],
            },
            commune: null,
            subscription: null,

        }
    },

    mounted() {
        this.getUser();

        setTimeout(() => {
            this.getAnomalies();
        }, 2000);

        this.subscribe();
    },

    created() {
        this.initFilters();
    },

    destroyed() {
        this.unsubscribe();
    },

    watch: {
        anomalies() {
            this.initFilters();
        },

        dialog(val) {
            val || this.close();
        },
        dialogDelete(val) {
            val || this.closeDelete();
        },


    },
    computed: {
        headers() {
            return [
                {
                    text: "id",
                    align: "start",
                    sortable: false,
                    value: "ids",
                },
                { text: "Date", value: "DateS", sortable: true, "sort-by": "-DateS" },
                {
                    text: "Type", value: "type",
                    filter: value => {
                        return this.activeFilters.type ? this.activeFilters.type.includes(value) : true;
                    }
                },
                {
                    text: "Etat", value: "etat",
                    filter: value => {
                        return this.activeFilters.etat ? this.activeFilters.etat.includes(value) : true;
                    }
                },
                { text: "Actions", value: "actions", sortable: false },
            ]
        },
        etatColorMap() {
            return {
                "refusée": "red",
                "en cours": "yellow",
                "traitée": "green",
                "non traitée": "orange",
            };
        }
    },
    methods: {

        subscribe() {
            this.subscription =
                supabase
                    .channel('any')
                    .on('postgres_changes', { event: '*', schema: 'public', table: 'signalement' }, payload => {
                        console.log('Change received!', payload)
                        this.getAnomalies();
                    })
                    .subscribe()

        },

        unsubscribe() {
            supabase.removeChannel(this.subscription)
        },


        async getUser() {
            const { data: { user } } = await supabase.auth.getUser();
            this.updatedAnomaly.foncitonnaire = user.id
            console.log(this.updatedAnomaly.foncitonnaire)

            const { data, error } = await supabase
                .from('fonctionnaires')
                .select('*')
                .eq('id', this.updatedAnomaly.foncitonnaire)
            console.log(data)
            if (error) {
                console.log(error)
            } else {
                this.commune = data[0].commune
                console.log("success commune")
            }
        },

        async getInfo() {

        },

        async getAnomalies() {
            const { data, error } = await supabase
                .from('signalement')
                .select('*')
                .eq('commune', this.commune)
                .order('DateS', { ascending: false })
            console.log(data)
            if (error) {
                console.log(error)
            } else {
                this.anomalies = data
                console.log("success")
            }
        },

        // async getAnomaly(id) {
        //     const { data, error } = await supabase
        //         .from('signalement')
        //         .select('*')
        //         .eq('idS', id).single()
        //     if (error) {
        //         console.log(error)
        //     } else {
        //         this.anomaly = data
        //         console.log("success")
        //     }
        // },

        async deleteAnomaly(id) {
            const { data, error } = await supabase
                .from('signalement')
                .delete()
                .eq('ids', id)
            if (error) {
                console.log(error)
            } else {
                console.log("success")
                this.closeDelete()
            }
        },

        // async showDetails(id) {
        //     this.selectedId = id;
        //     this.dialogDetails = true;
        //     console.log(this.selectedId)
        //     const { data, error } = await supabase
        //         .from('signalement')
        //         .select()
        //         .eq('ids', id).single();
        //     console.log(data)
        //     if (error) {
        //         console.log(error)
        //     } else {

        //         const { data: imagesData, error: imagesError } = await supabase
        //             .from('multimedia')
        //             .select()
        //             .eq('ids', id);
        //         console.log("this is images ",imagesData)
        //         if (imagesError) {
        //             console.log(imagesError);
        //         } else {

        //         const { lat, lon } = data;
        //         const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}&zoom=18&addressdetails=1`;
        //         const response = await fetch(url);
        //         const address = await response.json();
        //         console.log(address)
        //         if (address) {
        //             this.anomaly = data
        //             this.anomaly.address = address.display_name;
        //             this.anomaly.images = imagesData.img;
        //         }
        //         console.log("anomaly",this.anomaly)
        //     }
        // }
        // },


        async showDetails(id) {
            this.selectedId = id;
            this.dialogDetails = true;
            console.log(this.selectedId);

            const { data: anomalyData, error: anomalyError } = await supabase
                .from('signalement')
                .select()
                .eq('ids', id)
                .single();

            if (anomalyError) {
                console.log(anomalyError);
            } else {
                const { lat, lon } = anomalyData;
                const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}&zoom=18&addressdetails=1`;
                const response = await fetch(url);
                const address = await response.json();
                console.log(address);

                const { data: imagesData, error: imagesError } = await supabase
                    .from('multimedia')
                    .select('img, description')
                    .eq('ids', id);

                if (imagesError) {
                    console.log(imagesError);
                } else {
                    const images = imagesData.map((imageData) => imageData.img);
                    const descriptions = imagesData.map((imageData) => imageData.description);

                    this.anomaly = {
                        ...anomalyData,
                        address: address.display_name,
                        images: images,
                        description: descriptions,
                    };
                    console.log(this.anomaly);
                }
            }
        },

        // method to  update the anomaly etat 
        async updateAnomaly(id) {
            const { data, error } = await supabase
                .from('signalement')
                .update({
                    etat: this.updatedAnomaly.etat,
                    idF: this.updatedAnomaly.foncitonnaire,
                    DateT: this.updatedAnomaly.DateT,
                })
                .eq('ids', id);

            console.log(data)
            if (error) {
                console.log(error)
                this.closeEdit()
            } else {
                console.log("success")
                this.closeEdit()
            }
        },

        deleteItem(id) {
            this.dialogDelete = true;
            this.selectedId = id;
        },
        closeDelete() {
            this.dialogDelete = false;
        },
        closeEdit() {
            this.dialogEdit = false;
        },
        editItem(id) {
            this.selectedId = id;
            this.dialogEdit = true;
        },

        initFilters() {
            for (let col in this.filters) {
                this.filters[col] = this.anomalies.map((d) => { return d[col] }).filter(
                    (value, index, self) => { return self.indexOf(value) === index }
                )
            }
            this.activeFilters = Object.assign({}, this.filters)
        },

        toggleAll(col) {
            this.activeFilters[col] = this.anomalies.map((d) => { return d[col] }).filter(
                (value, index, self) => { return self.indexOf(value) === index }
            )
        },

        clearAll(col) {
            this.activeFilters[col] = []
        },
    }
}
</script>

<style scoped>
.img {
    width: 300px;
}

.det {
    margin-top: 25px;
    font-size: 20px;
    font-style: bold;
}

.align-center {
    align-items: center;
}
</style>