import React, {Component} from 'react';
import factory from '../SmartContract/factory'
import { Card, Button } from "semantic-ui-react";
import Layout from '../components/Layout';
import {Link} from '../routes';

class FundraiseList extends Component {

  static async getInitialProps(){
    const campaigns = await factory.methods.getDeployedCampaigns().call();

    return { campaigns };
  }

  renderCampaigns() {
    const items = this.props.campaigns.map((address) => {
      return {
        header: address,
        description: (
          <Link route={`/campaigns/${address}`}>
            <Button>View Campaign</Button>
          </Link>
        ),
        fluid: true,
      };
    });
    return <Card.Group items={items} />;
  }

  render(){
    return <Layout>
      <div>

        <h3>Open Campaigns</h3>
          <Link route="/campaigns/new_campaign">
            <a><Button
              floated="right"
              content="Create Campaign"
              icon="add"
              primary
            />
            </a>
          </Link>
        {this.renderCampaigns()} 
      
      </div>
    </Layout>
  }
}

export default FundraiseList;
