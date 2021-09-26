import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import Modal from "react-modal";
import { Tab, TabPanel, Tabs, TabList } from "react-web-tabs";
import "./MachineType.css";
import { BsFillPlusSquareFill } from "react-icons/bs";
import "react-web-tabs/dist/react-web-tabs.css";
import MachineMaintenances from "../MachineMaintenances/MachineMaintenances";

class MachineType extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      type: this.props.type,
      showModal: null,
    };

    this.getMaintenances();
  }

  validateForm() {
    return this.state.type.length > 0;
  }

  getMaintenances() {
    fetch(
      `http://192.168.1.153:4000/machines/getMaintenanceTasks/${this.state.type}`,
      {
        method: "GET",
        credentials: "same-origin",
        headers: {
          "Content-Type": "application/json",
        },
      }
    )
      .then((response) => response.json())
      .then((res) => {
        let types = [];

        this.setState({
          maintenances: res,
        }),
          () => console.log(this.state);
      });
  }

  renderTypeTabPanels() {
    let TabPanels = [];

    return TabPanels;
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  render() {
    return (
      <div>
        <Tabs defaultTab="vertical-tab-one" vertical className="vertical-tabs">
          <TabList>
            <Tab
              tabFor="new"
              style={{ width: "100%" }}
              className="definition-tab"
            >
              <BsFillPlusSquareFill />
            </Tab>
          </TabList>
          {this.renderTypeTabPanels()}
        </Tabs>
      </div>
    );
  }
}

export default withRouter(MachineType);
