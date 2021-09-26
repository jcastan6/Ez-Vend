import React, { Component } from "react";
import { Card, Container, Jumbotron, Row, Col, Button } from "react-bootstrap";
import Modal from "react-modal";
import Header from "./Components/Header/Header";
import { retrieveCookie } from "./Components/Cookies";
import { Tab, TabPanel, Tabs, TabList } from "react-web-tabs";
import NewType from "./Components/NewType";
import MachineType from "./Components/MachineType/MachineType.js";
import { BsFillPlusSquareFill } from "react-icons/bs";
import MachineMaintenances from "./Components/MachineMaintenances/MachineMaintenances";
import NewClient from "./Components/NewClient/NewClient";
import ClientEditor from "./Components/ClientEditor/ClientEditor";
import NewEmployee from "./Components/Employees/NewEmployee";
import EmployeeEditor from "./Components/Employees/EmployeeEditor";
import "react-web-tabs/dist/react-web-tabs.css";
import "./app.css";
export default class Definitions extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: retrieveCookie(),
      latestImages: [],
      showModal: false,
      types: [],
      clients: [],
      employees: [],
    };
    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
    this.renderClientPanels = this.renderClientPanels.bind(this);
    this.renderClientTypes = this.renderClientTypes.bind(this);
    this.renderEmployees = this.renderEmployees.bind(this);
    this.renderEmployeePanels = this.renderEmployeePanels.bind(this);
    this.renderTypes = this.renderTypes.bind(this);
    this.getTypes = this.getTypes.bind(this);
    this.getClients = this.getClients.bind(this);
    this.getEmployees = this.getEmployees.bind(this);
    this.refreshCycle = this.refreshCycle.bind(this);
    this.getEmployees();
    this.getTypes();
    this.getClients();
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  getEmployees() {
    this.setState({
      employees: [],
    });
    fetch(`http://192.168.1.153:4000/users/getEmployees`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        res.sort((a, b) => (a.name > b.name ? 1 : -1));
        this.setState(
          {
            employees: res,
          },
          () => console.log()
        );
      });
  }

  getTypes() {
    fetch(`http://192.168.1.153:4000/machines/getTypes`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        res.sort((a, b) => (a.type > b.type ? 1 : -1));
        this.setState(
          {
            types: res,
          },
          () => console.log()
        );
      });
  }
  getClients() {
    fetch(`http://192.168.1.153:4000/Clients/getAll`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        res.sort((a, b) => (a.name > b.name ? 1 : -1));
        this.setState(
          {
            clients: res,
          },
          () => console.log()
        );
      });
  }

  renderTypes() {
    let latest = [];

    latest.push(
      <div>
        <Tab tabFor="new" style={{ width: "100%" }} className="definition-tab">
          <BsFillPlusSquareFill />
        </Tab>
      </div>
    );

    if (this.state.types.length >= 1) {
      for (let i = 0; i < this.state.types.length; i++) {
        latest.push(
          <div>
            <Tab tabFor={this.state.types[i].type} style={{ width: "100%" }}>
              {this.state.types[i].type}
            </Tab>
          </div>
        );
      }
    }

    return latest;
  }

  renderPanels() {
    let latest = [];
    latest.push(
      <TabPanel tabId="new">
        <NewType getTypes={this.getTypes} history={this.props.history} />
      </TabPanel>
    );

    return latest;
  }

  renderClientTypes() {
    let latest = [];
    latest.push(
      <div>
        <Tab tabFor="new" style={{ width: "100%" }} className="definition-tab">
          <BsFillPlusSquareFill />
        </Tab>
      </div>
    );

    if (this.state.clients.length >= 1) {
      for (let i = 0; i < this.state.clients.length; i++) {
        latest.push(
          <div>
            <Tab tabFor={this.state.clients[i].name} style={{ width: "100%" }}>
              {this.state.clients[i].name}
            </Tab>
          </div>
        );
      }
    }
    return latest;
  }
  renderClientPanels() {
    let latest = [];
    latest.push(
      <TabPanel tabId="new">
        <NewClient getClients={this.refreshCycle}></NewClient>
      </TabPanel>
    );
    if (this.state.clients.length >= 1) {
      for (let i = 0; i < this.state.clients.length; i++) {
        latest.push(
          <div>
            <TabPanel tabId={this.state.clients[i].name}>
              <ClientEditor
                getClients={this.refreshCycle}
                client={this.state.clients[i]}
              ></ClientEditor>
            </TabPanel>
          </div>
        );
      }
    }
    return latest;
  }

  renderEmployees() {
    let latest = [];
    latest.push(
      <div>
        <Tab tabFor="new" style={{ width: "100%" }} className="definition-tab">
          <BsFillPlusSquareFill />
        </Tab>
      </div>
    );

    if (this.state.employees.length >= 1) {
      for (let i = 0; i < this.state.employees.length; i++) {
        latest.push(
          <div>
            <Tab
              tabFor={this.state.employees[i].name}
              style={{ width: "100%" }}
            >
              {this.state.employees[i].name}
            </Tab>
          </div>
        );
      }
    }
    return latest;
  }

  refreshCycle() {
    this.setState({
      user: retrieveCookie(),
      latestImages: [],
      showModal: false,
      types: [],
      clients: [],
      employees: [],
    });
    this.getClients();
    this.getEmployees();
    this.getTypes();
    this.renderClientPanels();
    this.renderClientTypes();
    this.renderEmployees();
    this.renderEmployeePanels();
  }

  renderEmployeePanels() {
    let latest = [];
    latest.push(
      <TabPanel tabId="new">
        <NewEmployee getEmployees={this.getEmployees}></NewEmployee>
      </TabPanel>
    );
    if (this.state.employees.length >= 1) {
      for (let i = 0; i < this.state.employees.length; i++) {
        latest.push(
          <div>
            <TabPanel tabId={this.state.employees[i].name}>
              <EmployeeEditor
                getEmployees={this.refreshCycle}
                employee={this.state.employees[i]}
              ></EmployeeEditor>
            </TabPanel>
          </div>
        );
      }
    }
    return latest;
  }

  render() {
    return (
      <div>
        <Header></Header>
        <div className="body">
          <Jumbotron>
            <Container fluid>
              <h1>Machine Types</h1>
              <Tabs defaultTab="vertical-tab-one" vertical>
                <TabList className="definition-tabs">
                  {this.renderTypes()}
                </TabList>
                {this.renderPanels()}
              </Tabs>
            </Container>
          </Jumbotron>
          <Jumbotron>
            <Container fluid>
              <h1>Clients</h1>
              <Tabs
                defaultTab="vertical-tab-one"
                vertical
                className="vertical-tabs"
              >
                <TabList>{this.renderClientTypes()}</TabList>
                {this.renderClientPanels()}
              </Tabs>
              <p />
            </Container>
          </Jumbotron>
          <Jumbotron>
            <Container fluid>
              <h1>Employees</h1>
              <p />
              <Tabs
                defaultTab="vertical-tab-one"
                vertical
                className="vertical-tabs"
              >
                <TabList>{this.renderEmployees()}</TabList>
                {this.renderEmployeePanels()}
              </Tabs>
            </Container>
          </Jumbotron>
        </div>
      </div>
    );
  }
}
