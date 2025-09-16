const { sfdx, fs, path } = require('./dependencies');

class OrgSetup {
  static async execute() {
    try {
      console.log('Starting Salesforce PropertyHub Org Setup...');
      
      // Create scratch org
      await this.createScratchOrg();
      
      // Push source code
      await this.pushSource();
      
      // Assign permission sets
      await this.assignPermissionSets();
      
      // Load sample data
      await this.loadSampleData();
      
      console.log('Org setup completed successfully!');
    } catch (error) {
      console.error('Org setup failed:', error.message);
    }
  }

  static async createScratchOrg() {
    console.log('Creating scratch org...');
    await sfdx.force.org.create({
      setalias: 'PropertyHubDev',
      definitionfile: 'config/project-scratch-def.json',
      durationdays: 7,
      setdefaultusername: true,
      json: true
    });
  }

  static async pushSource() {
    console.log('Pushing source code...');
    await sfdx.force.source.push();
  }

  static async assignPermissionSets() {
    console.log('Assigning permission sets...');
    
    const permissionSets = [
      'Property_Manager',
      'Sales_Agent',
      'Sales_Manager'
    ];

    for (const ps of permissionSets) {
      await sfdx.force.user.permset.assign({
        permsetname: ps,
        targetusername: 'PropertyHubDev'
      });
    }
  }

  static async loadSampleData() {
    console.log('Loading sample data...');
    await sfdx.force.data.tree.import({
      plan: 'data/sample-data-plan.json',
      targetusername: 'PropertyHubDev'
    });
  }
}

module.exports = OrgSetup;