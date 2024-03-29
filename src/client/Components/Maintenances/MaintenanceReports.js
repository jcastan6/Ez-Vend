import React, { Component } from "react";
import { Route, withRouter, Link } from "react-router-dom";
import Modal from "react-modal";
import {
  Button,
  FormGroup,
  FormControl,
  FormLabel,
  Image,
  Card,
  Carousel,
  Container,
  Jumbotron,
  Row,
  Col,
} from "react-bootstrap";
import "./Maintenances.css";
import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";
import DataTable, { createTheme } from "react-data-table-component";
import maintenanceHistory from "../../../server/models/maintenanceHistory";
import { BsCamera, BsThreeDotsVertical } from "react-icons/bs";
import ReportEditor from "./ReportEditor";
import ReactTooltip from "react-tooltip";
import NewReport from "./NewReport";

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

class MaintenanceReports extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      machine: this.props.machine,
      maintenances: [],
      showModal: false,
      pending: true,
    };
    this.getMaintenances = this.getMaintenances.bind(this);
    this.getMaintenances();
    this.renderModals = this.renderModals.bind(this);
    this.handleOpenModal = this.handleOpenModal.bind(this);
    this.handleCloseModal = this.handleCloseModal.bind(this);
  }

  handleOpenModal(id) {
    this.setState({ showModal: id });
  }

  handleCloseModal() {
    this.setState({ showModal: false });
  }

  handleRouteChange() {
    window.location.reload(false);
  }

  getMaintenances() {
    this.setState({ pending: true });
    fetch(`https://www.mantenimientoscvm.com/machines/getMachineReports/`, {
      body: JSON.stringify(this.state),
      method: "POST",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((res) => {
        res.forEach((element) => {
          element.createdAt = String(element.createdAt).split("T")[0];
        });

        this.setState({
          maintenances: res,
          pending: false,
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
                <ReportEditor
                  getMaintenances={this.getMaintenances}
                  report={element}
                ></ReportEditor>
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
        name: "Task",
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
        name: "Reported",
        selector: "createdAt",
        sortable: true,
      },
      {
        cell: (row) => {
          if (row.image) {
            return <BsCamera></BsCamera>;
          }
        },
      },

      {
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
          <NewReport
            machine={this.state.machine}
            getMaintenances={this.getMaintenances}
          ></NewReport>
          <DataTable
            data={this.state.maintenances}
            noHeader
            theme="machines"
            columns={columns}
            pagination
            progressPending={this.state.pending}
            progressComponent={<CustomLoader />}
            highlightOnHover
            pointerOnHover
            onRowDoubleClicked={(row) => {
              this.handleOpenModal(row.id);
            }}
          />
        </Card>
      </div>
    );
  }

  render() {
    return <div>{this.renderTasks()}</div>;
  }
}
export default withRouter(MaintenanceReports);
