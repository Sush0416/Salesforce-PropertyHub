import { LightningElement, track } from 'lwc';
import importProperties from '@salesforce/apex/DataManagementController.importProperties';
import importLeads from '@salesforce/apex/DataManagementController.importLeads';
import exportProperties from '@salesforce/apex/DataManagementController.exportProperties';
import exportLeads from '@salesforce/apex/DataManagementController.exportLeads';
import getImportHistory from '@salesforce/apex/DataManagementController.getImportHistory';
import getDataStatistics from '@salesforce/apex/DataManagementController.getDataStatistics';

export default class DataManagementConsole extends LightningElement {
    @track importHistory = [];
    @track dataStats = {};
    @track isLoading = false;
    @track activeTab = 'import';

    connectedCallback() {
        this.loadImportHistory();
        this.loadDataStatistics();
    }

    loadImportHistory() {
        getImportHistory()
            .then(result => {
                this.importHistory = result;
            })
            .catch(error => {
                console.error('Error loading import history:', error);
            });
    }

    loadDataStatistics() {
        getDataStatistics()
            .then(result => {
                this.dataStats = result;
            })
            .catch(error => {
                console.error('Error loading data statistics:', error);
            });
    }

    handleTabClick(event) {
        this.activeTab = event.target.dataset.tab;
    }

    handleFileUpload(event) {
        const file = event.target.files[0];
        if (file) {
            this.processFile(file);
        }
    }

    processFile(file) {
        this.isLoading = true;
        const reader = new FileReader();

        reader.onload = (e) => {
            const csvData = e.target.result;
            this.importData(csvData);
        };

        reader.readAsText(file);
    }

    importData(csvData) {
        const importMethod = this.activeTab === 'properties' ? importProperties : importLeads;

        importMethod({ csvData: csvData })
            .then(result => {
                this.showToast('Success', result, 'success');
                this.loadImportHistory();
                this.loadDataStatistics();
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    exportData() {
        this.isLoading = true;
        const exportMethod = this.activeTab === 'properties' ? exportProperties : exportLeads;
        const statusFilter = this.template.querySelector('.status-filter')?.value || 'All';

        exportMethod({ statusFilter: statusFilter })
            .then(result => {
                this.downloadFile(result, this.activeTab === 'properties' ? 'properties.csv' : 'leads.csv');
                this.showToast('Success', 'Data exported successfully', 'success');
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    downloadFile(content, filename) {
        const blob = new Blob([content], { type: 'text/csv' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        a.click();
        window.URL.revokeObjectURL(url);
    }

    showToast(title, message, variant) {
        // Create and dispatch toast event
        const toastEvent = new CustomEvent('showtoast', {
            detail: { title, message, variant }
        });
        this.dispatchEvent(toastEvent);
    }

    get isImportTab() {
        return this.activeTab === 'import';
    }

    get isExportTab() {
        return this.activeTab === 'export';
    }

    get isHistoryTab() {
        return this.activeTab === 'history';
    }

    get isStatsTab() {
        return this.activeTab === 'stats';
    }
}
