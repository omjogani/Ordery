import React, { useEffect, useState } from "react";
import DataTable from "react-data-table-component";

export default function FetchApi() {
  const [orders, setOrders] = useState([]);
  const [search, setSearch] = useState("");

  let [filteredOrder, setFilteredOrder] = useState([]);

  const getServed = async (oid) => {
    try {
      const orderId = {
        id: oid,
      };
      let responseData;

      console.log("server: ", oid);
      await fetch("/orderUpdate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(orderId),
        // body: orderId
      })
        .then((resData) => resData.json())
        .then((json) => {
          console.log(json);
          responseData = json;
          // setFilteredOrder(json);
          getOrders();
        });
      // setOrders(responseData);
    } catch (error) {
      console.log(error);
    }
  };

  const getOrders = async () => {
    try {
      const response = await fetch("/orders")
        .then((resData) => resData.json())
        .then((json) => {
          setOrders(json);
          setFilteredOrder(json);
        });
    } catch (error) {
      console.log(error);
    }
  };

  const columns = [
    {
      name: "Order Id",
      selector: (row) => row.orderId,
    },
    {
      name: "Name",
      selector: (row) => row.name,
      sortable: true,
    },
    {
      name: "Item Name",
      selector: (row) => row.order[0].itemName,
    },
    {
      name: "Quantity",
      selector: (row) => row.order[0].quantity,
    },
    {
      name: "Serve",
      selector: (row) => (
        <button
          className="btn btn-primary bt-sm"
          onClick={() => {
            getServed(row.orderId);
          }}
        >
          Served
        </button>
      ),
    },
  ];

  useEffect(() => {
    getOrders();
  }, []);

  // For Searching Purpose
  useEffect(() => {
    const result = orders.filter((order) => {
      return order.name.toLowerCase().match(search.toLowerCase());
    });
    setFilteredOrder(result);
  }, [search]);

  return (
    <div className=".container">
      <DataTable
        title="Pending Orders"
        fixedHeader
        highlightOnHover
        columns={columns}
        data={filteredOrder}
        pagination
        subHeader
        subHeaderComponent={
          <input
            type="text"
            placeholder="Search here"
            className="w-25 form-control"
            value={search}
            onChange={(e) => {
              setSearch(e.target.value);
            }}
          />
        }
        subHeaderAlign="left"
      />
    </div>
  );
}
