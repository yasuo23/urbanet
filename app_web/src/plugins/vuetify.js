import Vue from 'vue';
import Vuetify from 'vuetify/lib/framework';

Vue.use(Vuetify);

export default new Vuetify({
    theme: {
        themes: {
            light: {
                primary: '#0300ac', //red color
                secondary: '#2C2A3A', //the black color, mainly used for text
                notify: '#FFD29E', //the yellowy color for notifications and stuff
                background: '#EEF0FA', //the light blue color for the background of the page
            },
        },
    },
});
