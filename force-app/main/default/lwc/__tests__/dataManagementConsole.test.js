import { createElement } from 'lwc';
import DataManagementConsole from 'c/dataManagementConsole';

describe('c-data-management-console', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('should initialize component', () => {
        const element = createElement('c-data-management-console', {
            is: DataManagementConsole
        });
        document.body.appendChild(element);

        expect(element).toBeTruthy();
        expect(element.selectedTab).toBe('import');
    });

    // Add more test cases here
});