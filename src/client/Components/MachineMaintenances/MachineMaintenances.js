import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import Modal from "react-modal";
import { Tab, TabPanel, Tabs, TabList } from "react-web-tabs";
import "./MachineMaintenances.css";
import { BsFillPlusSquareFill } from "react-icons/bs";
import "react-web-tabs/dist/react-web-tabs.css";
import NewMaintenance from "../Maintenances/NewMaintenance";
import TaskEditor from "../TaskEditor/TaskEditor";
import "../Definitions.css";
class MachineMaintenances extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      type: this.props.type,
      showModal: null,
      tasks: [],
    };
    this.getMaintenances = this.getMaintenances.bind(this);
    this.getMaintenances();
  }

  handleRouteChange() {
    window.location.reload(false);
  }

  validateForm() {
    return this.state.type.length > 0;
  }

  getMaintenances() {
    fetch(
      `http://localhost:4000/machines/getMaintenanceTasks?machineType=${this.props.type}`,
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
        this.setState({
          tasks: res,
        }),
          () => console.log();
      });
  }

  renderTabPanels() {
    let TabPanels = [];
    if (this.state.tasks.length > 0) {
      for (let i = 0; i < this.state.tasks.length; i++) {
        let task = this.state.tasks[i];
        TabPanels.push(
          <TabPanel className="tab-panel" tabId={task.id}>
            <TaskEditor
              className="tab-panel"
              getMaintenances={this.getMaintenances}
              task={task}
            />
          </TabPanel>
        );
      }
    }
    return TabPanels;
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  renderTabs() {
    let tabs = [];
    if (this.state.tasks.length > 0) {
      for (let i = 0; i < this.state.tasks.length; i++) {
        let task = this.state.tasks[i];
        tabs.push(
          <Tab
            tabFor={task.id}
            style={{ width: "100%" }}
            className="definition-tab"
          >
            {task.task}
          </Tab>
        );
      }
    }
    return tabs;
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
            {this.renderTabs()}
          </TabList>
          <TabPanel tabId="new">
            <NewMaintenance
              getMaintenances={this.getMaintenances}
              type={this.props.type}
            ></NewMaintenance>
          </TabPanel>
          {this.renderTabPanels()}
        </Tabs>
      </div>
    );
  }
}

export default withRouter(MachineMaintenances);
