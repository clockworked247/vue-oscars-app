import Home from './components/Home.vue';
import App from './components/app/App.vue';
import Queries from './components/queries/Queries.vue';

export const routes = [
    { path: '/', component: Home },
    { path: '/app', component: App },
    { path: '/queries', component: Queries }
];