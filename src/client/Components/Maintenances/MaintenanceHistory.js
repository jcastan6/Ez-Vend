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
} from "react-bootstrap";
import DataTableExtensions from "react-data-table-component-extensions";
import "react-data-table-component-extensions/dist/index.css";
import DataTable, { createTheme } from "react-data-table-component";
import maintenanceHistory from "../../../server/models/maintenanceHistory";

class MaintenanceHistory extends Component {
  constructor(props) {
    super(props);
    this.handleRouteChange = this.handleRouteChange.bind(this);
    this.state = {
      machine: this.props.machine,
      maintenances: [],
    };
    this.getMaintenances = this.getMaintenances.bind(this);
    this.getMaintenances();
  }

  handleRouteChange() {
    window.location.reload(false);
  }

  getMaintenances() {
    fetch(`http://localhost:4000/machines/getMaintenanceHistory/`, {
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

  renderTasks() {
    const columns = [
      {
        name: "Task",
        selector: "task",
        sortable: true,
      },
      {
        name: "Date",
        selector: "createdAt",
        sortable: true,
      },
      {
        name: "Type",
        selector: "pastDue",
        sortable: true,
      },
      {
        name: "Completed by",
        selector: "reminderAt",
        sortable: true,
      },
    ];
    return (
      <Card body>
        <Card.Title>Maintenance History</Card.Title>
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
          />
        </DataTableExtensions>
      </Card>
    );
  }

  render() {
    return <div>{this.renderTasks()}</div>;
  }
}
export default withRouter(MaintenanceHistory);
