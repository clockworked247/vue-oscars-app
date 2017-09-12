import Vue from 'vue';

export const loadData = ({commit}) => {
    Vue.http.get('documents?uri=/oscars-app.json')
        .then(response => response.json())
        .then(data => {
            if (data) {
                const queries       = data.queries;
                const currentQuery  = data.currentQuery;
                const activeFacets  = data.activeFacets;
                
                commit('SET_QUERIES', queries || []);
                commit('UPDATE_CURRENT_QUERY', currentQuery || '');
                commit('SET_FACETS', activeFacets || []);
            }
        });
};

export const getDoc = ({commit}, uri) => {
    Vue.http.get('documents?uri=' + uri)
        .then(data => {
            if (data) {
                commit('UPDATE_CURRENT_DOC', data);
            }
        });
};

export const saveData = ({commit}, data) => {
    console.log("saveData");
    console.log(data);
    Vue.http.put('documents?uri=/oscars-app.json', data)
        .then(response => response.json())
        .then(data => {
            if (data) {
                console.log("SAVED SUCCESSFULLY");
            }
        });
};
