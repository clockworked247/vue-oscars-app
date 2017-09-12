import uuid from 'uuid';

const state = {
    queries: []
};

const mutations = {
    'SET_QUERIES' (state, queries) {
        state.queries = queries;
    },
    'ADD_QUERY' (state, query) {
       const uuidv1 = require('uuid/v1');
       var q = {
            id: uuidv1(),
            query,
            date: Date.now()
        }
        state.queries.push(q);
    },
    'DELETE_QUERY' (state, query) {
        state.queries = _.difference(state.queries, [ query ]);
    }
};

const actions = {
    addQuery: ({commit}, query) => {
        commit('ADD_QUERY', query);
    },
    deleteQuery: ({commit}, query) => {
        commit('DELETE_QUERY', query);
    },
    initQueries: ({commit}, queries) => {
        commit('SET_QUERIES', queries); // from import above
    }
};

const getters = {
    queries: state => {
        return state.queries;
    }
};

export default {
    state,
    mutations,
    actions,
    getters
};