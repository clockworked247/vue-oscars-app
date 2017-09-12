import Vue from 'vue';
import Vuex from 'vuex';

import queries from './modules/queries';
import search from './modules/search';

import * as actions from './actions';

Vue.use(Vuex);

export default new Vuex.Store({
    actions,
    modules: {
        queries,
        search
    }
});