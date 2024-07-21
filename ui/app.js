const { createApp } = Vue;

const app = createApp({
    data() {
        return {
            page: 0, 
            meta : null,
            quests: {},
            quest_entries: {},
        };
    },
    methods: {
        handleMessage(event) {
            if (event.data.type === 'display') {
                this.setpage(1);
                console.log("display");
            } else if (event.data.type === 'questlist') {
                this.setpage(2);
                console.log("Quest Editor");
            } else if (event.data.type === 'questentries') {
                this.setpage(3);
                console.log("Quest Entry Editor");
            }

            if (event.data.meta) {
                this.meta = event.data.meta;
            }
            if (event.data.quests) {
                this.quests = event.data.quests;
            }
            if (event.data.questentries) {
                this.quest_entries = event.data.questentries;
            }
        },
        handleKeydown(event) {
            // Handle keydown event here
            if (event.key === 'Escape') {
                this.close(null);
            }
        },
        setpage(page) {
            this.page = page;
        },
        selectQuest(data) {
            this.setpage(3);

            fetch(`https://${GetParentResourceName()}/selectquest`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
        close(data) {
            this.setpage(0);

            fetch(`https://${GetParentResourceName()}/close`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            }).then(response => response.json())
              .then(result => {}).catch(error => {});
        },
    },
    mounted() {
        window.addEventListener('message', this.handleMessage);
        window.addEventListener('keydown', this.handleKeydown);
    },
    unmounted() {
        window.removeEventListener('message', this.handleMessage);
        window.removeEventListener('keydown', this.handleKeydown);
    }
});

app.mount('#app');