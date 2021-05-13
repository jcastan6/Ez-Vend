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
export default class Definitions extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: retrieveCookie(),
      latestImages: [],
      showModal: false,
      types: [],
      clients: [],
    };
    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
    this.renderClientPanels = this.renderClientPanels.bind(this);
    this.renderClientTypes = this.renderClientTypes.bind(this);
    this.renderTypes = this.renderTypes.bind(this);
    this.getTypes = this.getTypes.bind(this);
    this.getClients = this.getClients.bind(this);
    this.getTypes();
    this.getClients();
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  getTypes() {
    fetch(`http://localhost:4000/machines/getTypes`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        this.setState(
          {
            types: res,
          },
          () => console.log()
        );
      });
  }
  getClients() {
    fetch(`http://localhost:4000/Clients/getAll`, {
      method: "GET",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
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
    if (this.state.types.length >= 1) {
      for (let i = 0; i < this.state.types.length; i++) {
        latest.push(
          <div>
            <TabPanel tabId={this.state.types[i].type}>
              <MachineMaintenances
                type={this.state.types[i].type}
              ></MachineMaintenances>
            </TabPanel>
          </div>
        );
      }
    }
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
        <NewClient></NewClient>
      </TabPanel>
    );
    if (this.state.clients.length >= 1) {
      for (let i = 0; i < this.state.clients.length; i++) {
        latest.push(
          <div>
            <TabPanel tabId={this.state.clients[i].name}></TabPanel>
          </div>
        );
      }
    }
    return latest;
  }

  render() {
    return (
      <div>
        <Header />
        <Jumbotron>
          <Container fluid>
            <h1>Machines </h1>
            <br />
            <Tabs
              defaultTab="vertical-tab-one"
              vertical
              className="vertical-tabs"
            >
              <TabList>{this.renderTypes()}</TabList>
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
            <h1>Rutas</h1>
            <p />
            {/* <Row className="justify-content-center">{this.latestImages()}</Row> */}
          </Container>
        </Jumbotron>
      </div>
    );
  }
}
