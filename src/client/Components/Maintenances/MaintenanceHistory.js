import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Image,
  Card,
  Carousel,
  Container,
  Row,
  Col,
} from "react-bootstrap";
import Modal from "react-modal";
import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";
import DataTable, { createTheme } from "react-data-table-component";
import HistoryEditor from "./HistoryEditor";
import ReactTooltip from "react-tooltip";
import { BsCamera, BsThreeDotsVertical } from "react-icons/bs";

import styled, { keyframes } from "styled-components";
const rotate360 = keyframes`
  from {
    transform: rotate(0deg);
  }

  to {
    transform: rotate(360deg);
  }
`;

const Spinner = styled.div`
  margin: 16px;
  animation: ${rotate360} 1s linear infinite;
  transform: translateZ(0);
  border-top: 2px solid grey;
  border-right: 2px solid grey;
  border-bottom: 2px solid grey;
  border-left: 4px solid black;
  background: transparent;
  width: 80px;
  height: 80px;
  border-radius: 50%;
`;

const CustomLoader = () => (
  <div style={{ padding: "24px" }}>
    <Spinner />
    <div>Cargando...</div>
  </div>
);

class MaintenanceHistory extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      machine: this.props.machine,
      maintenances: [],
      pending: true,
    };
    this.getMaintenances = this.getMaintenances.bind(this);
    this.getMaintenances();
    this.renderModals = this.renderModals.bind(this);
    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleRouteChange() {
    window.location.reload(false);
  }
  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  getMaintenances() {
    this.setState({ pending: true });
    fetch(`https://www.mantenimientoscvm.com/machines/getMaintenanceHistory/`, {
      body: JSON.stringify(this.state),
      method: "POST",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        this.setState({
          maintenances: res,
        }),
          () => console.log();
      });
  }

  renderModals() {
    const modals = [];
    for (const element of this.state.maintenances) {
      modals.push(
        <Modal
          shouldCloseOnOverlayClick={true}
          onRequestClose={this.handleCloseModal}
          className="modal-info"
          isOpen={this.state.showModal === element.id}
        >
          <Container>
            <Row>
              <Col>
                <HistoryEditor
                  getMaintenances={this.getMaintenances}
                  report={element}
                ></HistoryEditor>
              </Col>
              <Col>
                <Card>
                  <Card.Body>
                    <img src={element.image} width="100%"></img>
                  </Card.Body>
                </Card>
              </Col>
            </Row>
          </Container>
        </Modal>
      );
    }
    return modals;
  }
  renderTasks() {
    const columns = [
      {
        name: "Mantenimiento",
        cell: (row) => {
          return (
            <div data-tip={row.task}>
              {row.task} <ReactTooltip />
            </div>
          );
        },
        cellExport: (row) => {
          return row.task;
        },
        sortable: true,
      },
      {
        name: "Realizado?",
        selector: "createdAt",
        sortable: true,
      },
      {
        name: "Realizado Por:",
        selector: "employee",
        sortable: true,
      },
      {
        name: "Editar",
        cell: (row) => {
          return (
            <BsThreeDotsVertical
              onClick={() => this.handleOpenModal(row.id)}
            ></BsThreeDotsVertical>
          );
        },
      },
    ];

    return (
      <div>
        {this.renderModals()}
        <Card body className="table">
          <Card.Title>Historial de Mantenimiento</Card.Title>
          <DataTableExtensions
            filterHidden={false}
            columns={columns}
            data={this.state.maintenances}
          >
            <DataTable
              data={this.state.maintenances}
              noHeader
              theme="machines"
              columns={columns}
              pagination
              highlightOnHover
              pointerOnHover
              onRowDoubleClicked={(row) => {
                this.handleOpenModal(row.id);
              }}
            />
          </DataTableExtensions>
        </Card>
      </div>
    );
  }

  render() {
    return <div>{this.renderTasks()}</div>;
  }
}
export default withRouter(MaintenanceHistory);
