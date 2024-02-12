import { useState } from 'react';
import {ethers} from 'ethers';
import Lock from "./artifacts/contracts/Lock.sol/Lock.json";
import logo from './logo.svg';
import './App.css';

//import ABI code to interact with smart contract
const lockAddress = "0x5fbdb2315678afecb367f032d93f642f64180aa3";


function App() {
  // helper functions
  // request access to the user's MetaMask Wallet account
  async function requestAccount() {
    await window.ethereum.request({method: "eth_requestAccounts"})
  }
  // Fetches the current value store in Lock
  async function fetchLock() {
    // If Metamask exist
    if (typeof window.ethereum != "undefined") {
      //const provider = new ethers.providers.Web3Provider(window.ethereum);
      //const contract = new ethers.Contract(lockAddress, Lock.abi, provider)
    }

  }


  return (
    <div className="App">
        <div className='App-header'>
          {/* BUTTONS - Fetch and Set */}
          
          {/* INPUT TEXT - String */} 

          <div className='custom-input'>
          <input
              placeholder='Longitude' 
          />

          <input
              placeholder='Latitude' 
          />

          <input
              placeholder='distance' 
          /> 

          <input
              placeholder='Timestamp' 
          />

          </div> 

          <div className='Custom-button'>
            <button> Add Device </button>
            <button> Update Device Position </button>
          </div>
          
          

      </div>
      

      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
