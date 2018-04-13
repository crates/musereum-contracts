import fs from 'fs'
import Config from 'truffle-config'
import Resolver from 'truffle-resolver'
import compile from 'truffle-compile'

const { CONTRACT } = process.env
const { sourcePath, contractName, abi, ast } = require(`./build/contracts/${CONTRACT}.json`)

const docsHeadings = {
  'author': 'Authors',
  'notice': 'Summary',
  'dev': 'Note',
  'param': 'Parameters',
  'return': 'Returns'
}

function w (exp) {
  console.log(exp)
}

function l (exp) {
  if (exp) {
    w(exp)
  }
  w('')
}

function outContract (raw, opts) {
  const options = Object.assign({
    headingPrefix: '# '
  }, opts)

  l(`${options.headingPrefix}${raw}`)
}

function outDocs (raw, opts) {
  const options = Object.assign({
    headingPrefix: '## '
  }, opts)

  const parts = raw.split(/(^|\W)@(\w+)/).filter(part => part.trim().length).map(part => part.trim())

  const docs = parts.reduce((acc, part, index, original) => {
    // Only key indexes
    if (index % 2 !== 0) {
      return acc
    }

    acc[part] = acc[part] || []
    acc[part].push(original[index + 1])

    return acc
  }, {})

  Object.keys(docs).forEach(key => {
    l(`${options.headingPrefix}${docsHeadings[key]}`)
    docs[key].forEach(doc => {
      l(doc)
    })
  })
}

function compileProject () {
  return new Promise((resolve, reject) => {
    if (fs.existsSync(`${process.env.PWD}/truffle.js`)) {
      const config = Config.default()
      config.resolver = new Resolver(config)
      config.rawData = true
      compile.all(config, (err, res) => {
        if (err) { throw err }
        resolve({
          contracts: Object.keys(res).reduce((o, k) => {
            const { metadata, ...data } = res[k].rawData
            try {
              const parsed = JSON.parse(metadata)
              const fN = Object.keys(parsed.settings.compilationTarget)[0]
              data.fileName = fN.indexOf(process.env.PWD) === 0 ? fN : `${process.env.PWD}/node_modules/${fN}`
              data.output = parsed.output
            } catch (e) {
              console.log(`⚠️ Error parsing Contract: ${k}`)
            }
            return {
              ...o,
              [k]: data
            }
          }, {})
        })
      })
    } else {
      reject(new Error('non truffle project'))
    }
  })
}

async function _run () {
  const contractsAst = ast.children.filter(child => child.name === 'ContractDefinition' && child.attributes.name === contractName)

  contractsAst.forEach(contract => {
    outContract(contract.attributes.name)
    if (contract.attributes.documentation) {
      outDocs(contract.attributes.documentation)
    }
  })

  console.log(await compileProject())
}

_run()
