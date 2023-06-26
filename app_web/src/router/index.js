import Vue from 'vue'
import VueRouter from 'vue-router'
import LoginView from '../views/LoginView.vue'
import DashboardView from '../views/DashboardView.vue'
import MapView from '../views/MapView.vue'
import SignalementView from '../views/SignalementsView.vue'
import UtilisateurView from '../views/UtilisateursView.vue'
import FonctionnaireView from '../views/FonctionnairesView.vue'
import MaSection from '../views/MaSectionView.vue'
import PropositionView from '../views/PropositionView.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'login',
    component: LoginView
  },
  {
    path: '/dashboard',
    name: 'dashboard',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: DashboardView,
    meta: { requiresAuth: true }
  },
  { 
    path: '/map',
    name: 'map',
    component: MapView,
    meta: { requiresAuth: true }
  },
  {
    path: '/signalements',
    name: 'signalements',
    component: SignalementView,
    meta: { requiresAuth: true }
  },
  {
    path: '/utilisateurs',
    name: 'utilisateurs',
    component: UtilisateurView
  },
  {
    path: '/fonctionnaires',
    name: 'fonctionnaires',
    component: FonctionnaireView
  },
  {
    path: '/MaSection',
    name: 'MaSection',
    component: MaSection
  },
  {
    path: '/Propositions',
    name: 'Propositions',
    component: PropositionView
  },

]

const router = new VueRouter({
  routes
})




export default router
